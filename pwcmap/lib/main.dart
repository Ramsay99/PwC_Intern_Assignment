import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screens/home.dart';

void main(List<String> args) {
  // _geolocationTest().then((value) => debugPrint(value));

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Pwcmap(),
  ));
}

/// [_geolocationTest] is a method to test a website API
///
/// To call this method
/// make sure to call it with
///
/// `.then()`
///
/// Example:
/// ```dart
/// _geolocationTest().then((value) => debugPrint(value));
/// ```
Future<String> _geolocationTest({String address = 'jordan, amman'}) async {
  String geolocationJSONText = '';
  const String authority = 'geocode.maps.co';
  const String unencodedPath = '/search';
  Uri urlSearch = Uri.https(authority, unencodedPath, {
    'q': {address}
  });

  var response = await http.get(urlSearch);
  geolocationJSONText += ('\nRequest: ${response.request}');
  if (response.statusCode == 200) {
    geolocationJSONText += ('\nBody: ${response.body}');
  } else {
    geolocationJSONText += ('\nStatus Failur Code: ${response.statusCode}');
  }

  return geolocationJSONText;
}
