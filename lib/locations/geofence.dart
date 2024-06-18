import 'package:nightview/locations/geofence_corner.dart';
import 'package:nightview/locations/geofence_center.dart';

class Geofence {
  final List<GeofenceCorner> corners;
  final GeofenceCenter center;
  final double radius = 10; // Define the radius in meters

  Geofence({required this.corners, required this.center});
}