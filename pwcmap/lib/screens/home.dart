import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pwcmap/utils/map/utils.dart';
import 'package:pwcmap/utils/map/tile_servers.dart';
import 'package:pwcmap/utils/map/viewport_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:pwcmap/utils/api/map_api.dart' as myApi;
import 'package:quickalert/quickalert.dart';

class Pwcmap extends StatefulWidget {
  const Pwcmap({super.key});

  @override
  State<Pwcmap> createState() => _PwcmapState();
}

class _PwcmapState extends State<Pwcmap> {
  final LatLng _pwcLatLng = const LatLng(31.956301451143744, 35.90826577794861);
  late final MapController mapController;
  late bool _darkMode;
  late TextEditingController textController;
  late double lat;
  late double lng;

  void changeTheme() {
    setState(() {
      _darkMode = !_darkMode;
    });
  }

  @override
  void initState() {
    super.initState();

    mapController = MapController(
      location: _pwcLatLng,
      zoom: 13,
    );
    _darkMode = false;
    textController = TextEditingController();
    lat = 0;
    lng = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Image.asset('pwc.jpeg'),
        elevation: 0,
        title: const Text(
          'Map',
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle ${_darkMode == true ? 'Light' : 'Dark'} Mode',
            onPressed: () {
              changeTheme();
            },
            icon: Icon(_darkMode == true ? Icons.wb_sunny : Icons.dark_mode,
                color: Colors.black),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            map(context),
            bottomSearchBar(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void _goToThis_LatLng(double lat, double lng) {
    mapController.center = LatLng(lat, lng);
    mapController.zoom = 10;
    setState(() {});
  }

  void _onDoubleTap(MapTransformer transformer, Offset position) {
    const delta = 0.5;
    final zoom = clamp(mapController.zoom + delta, 2, 18);

    transformer.setZoomInPlace(zoom, position);
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, MapTransformer transformer) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      mapController.zoom += 0.02;

      setState(() {});
    } else if (scaleDiff < 0) {
      mapController.zoom -= 0.02;
      if (mapController.zoom < 1) {
        mapController.zoom = 1;
      }
      setState(() {});
    } else {
      final now = details.focalPoint;
      var diff = now - _dragStart!;
      _dragStart = now;
      final h = transformer.constraints.maxHeight;

      final vp = transformer.getViewport();
      if (diff.dy < 0 && vp.bottom - diff.dy < h) {
        diff = Offset(diff.dx, 0);
      }

      if (diff.dy > 0 && vp.top - diff.dy > 0) {
        diff = Offset(diff.dx, 0);
      }

      transformer.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  map(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height - 120,
      child: MapLayout(
        controller: mapController,
        builder: (context, transformer) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTapDown: (details) => _onDoubleTap(
              transformer,
              details.localPosition,
            ),
            onScaleStart: _onScaleStart,
            onScaleUpdate: (details) => _onScaleUpdate(details, transformer),
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta.dy / -1000.0;
                  final zoom = clamp(mapController.zoom + delta, 2, 18);

                  transformer.setZoomInPlace(zoom, event.localPosition);
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  TileLayer(
                    builder: (context, x, y, z) {
                      final tilesInZoom = pow(2.0, z).floor();

                      while (x < 0) {
                        x += tilesInZoom;
                      }
                      while (y < 0) {
                        y += tilesInZoom;
                      }

                      x %= tilesInZoom;
                      y %= tilesInZoom;

                      return CachedNetworkImage(
                        imageUrl:
                            _darkMode ? googleDark(z, x, y) : google(z, x, y),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  CustomPaint(
                    painter: ViewportPainter(
                      transformer.getViewport(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _setLatLng({String address = 'jordan, amman'}) async {
    debugPrint('\nSearch Pressed');
    String cityname = '';
    dynamic jsonValue = '';

    // ToDo: use Api class to get response value, instead of [await http.ge...]
    // var forwardGe_String = myApi.Api.forwardGeocode('jordan, amman');
    http.Response response =
        await http.get(Uri.https('geocode.maps.co', '/search', {
      'q': {address}
    }));
    String resBodyText = response.body;

    if (resBodyText == "[]") {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text:
              'There were no cities found with the name ${textController.text}\nplease try again with a different city name.');
      return;
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: 'Please wait while fetching your data',
      autoCloseDuration: const Duration(seconds: 2),
    );

    jsonValue = jsonDecode(resBodyText)[0];
    debugPrint('jsonValue  = = =  $jsonValue');
    cityname = jsonValue['display_name'];
    lat = double.parse(jsonValue['lat']);
    lng = double.parse(jsonValue['lon']);
    debugPrint('cn $cityname\nlat $lat \nlng $lng');

    // This is temp Bug Solution, should be removed after code refactoring/cleaning.
    _goToThis_LatLng(lat, lng);
  }

  Padding bottomSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 35,
                  width: 260,
                  child: TextFormField(
                    maxLength: 19,
                    controller: textController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      focusColor: Colors.white,
                      //add prefix icon
                      prefixIcon: const Icon(
                        Icons.map,
                        color: Colors.grey,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      fillColor: Colors.grey,

                      //make hint text
                      hintStyle: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 16,
                        fontFamily: "verdana_regular",
                        fontWeight: FontWeight.w400,
                      ),

                      //create lable
                      labelText: 'City Name',
                      //lable style
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: "verdana_regular",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        _setLatLng(address: textController.text);
                        // !Bug: [lat,lng]: are sets after _goToThis_LatLng method is called.
                        // Temp Bug Solution, moved this inside [_setLatLng] method.
                        // _goToThis_LatLng(lat, lng);
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Oops...',
                          text:
                              'You left the Search Box Empty!\nPlease Enter City Name.',
                        );
                      }
                    },
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Image.asset(
                'PricewaterhouseCoopers.jpeg',
                height: 50,
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
