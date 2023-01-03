import 'package:flutter_test/flutter_test.dart';
import 'package:pwcmap/utils/api/map_api.dart' as myApi;

void main() {
  group(
    'geocode.maps.co/',
    () {
      test(
        // this test currenlty not working
        'geolocation for jordan, amman',
        () async {
          /// [geolocationTest] is a method to test a GET method from website API
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
            // geolocationJSONText += ('\nRequest: ${response.request}');
            // if (_isResponseCodeIsOK()) {
            //   geolocationJSONText += ('\nBody: ${response.body}');
            // } else {
            //   geolocationJSONText += ('\nStatus Failur Code: ${response.statusCode}');

            return geolocationJSONText;
          }
          // String str = await myApi.Api.('jordan, amman');
          // print(str);
          // expect('temp actual', str);
        },
      );
    },
  );
}
