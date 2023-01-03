/// Coordinates in Degrees.
class LatLng {
  /// Default Constructor.
  const LatLng(this.latitude, this.longitude);

  /// Latitude, Y Axis.
  final double latitude;

  /// Longitude, X Axis.
  final double longitude;

  /// Linear interpolation of two [LatLng]s.
  static LatLng lerp(LatLng a, LatLng b, double t) {
    final lat = _lerp(a.latitude, b.latitude, t);
    final lng = _lerp(a.longitude, b.longitude, t);

    return LatLng(lat, lng);
  }
}

double _lerp(double a, double b, double t) {
  return a * (1.0 - t) + b * t;
}
