// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;

class Api {
  static const String authority = 'geocode.maps.co';
  static const String forwardUnencodedPath = '/search';
  static String reverseUnencodedPath = '/reverse';
  static int statusCode_OK = 200;
  static late Uri uri;
  static late http.Response response;
  static late String address = 'EMPTY_ADDRESS';

  static Future<String> forwardGeocode(String address) async {
    Api.address = address;
    uri = Uri.https(authority, forwardUnencodedPath, {
      'q': {address}
    });
    response = await http.get(uri);

    return response.body;
  }

// Uri _getForwardGeocode_Uri() {}
  bool _isResponseCodeIsOK() {
    return response.statusCode == statusCode_OK;
  }
}
