import 'package:flutter_test/flutter_test.dart';
import 'package:pwcmap/utils/api/map_api.dart';

void main() {
  group(
    'geocode.maps.co/',
    () {
      test(
        // this test currenlty not working
        'geolocation for jordan, amman',
        () async {
          String str = await geolocateJSONText('jordan, amman');
          print(str);
          expect('temp actual', str);
        },
      );
    },
  );
}
