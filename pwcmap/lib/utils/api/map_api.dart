import 'package:http/http.dart' as http;

const String authority = 'geocode.maps.co';
const String searchUnencodedPath = '/search';

/// [geolocationTest] is a method to test a website API
///
/// To call this method
/// make sure to call it with
///
/// `.then()`
///
/// Example:
/// ```dart
/// geolocationTest('ADDRESS HERE').then((value) => debugPrint(value));
/// ```
Future<String> geolocateJSONText(String address) async {
  String geolocationJSONText = '';
  Uri urlSearch = Uri.https(authority, searchUnencodedPath, {
    'q': {address}
  });

  final http.Response response = await http.get(urlSearch);
  geolocationJSONText += ('\nRequest: ${response.request}');
  if (response.statusCode == 200) {
    geolocationJSONText += ('\nBody: ${response.body}');
  } else {
    geolocationJSONText += ('\nStatus Failur Code: ${response.statusCode}');
  }

  return geolocationJSONText;
}
