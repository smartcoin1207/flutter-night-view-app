
import 'package:nightview/constants/enums.dart';

class ClubData {

  final String id;
  final String name;
  final String logo;
  final double lat;
  final double lon;
  final int visitors;
  final List<dynamic> favorites;
  final List<dynamic> corners;
  final OfferType offerType;
  final String? mainOfferImg;

  ClubData({required this.id, required this.name, required this.logo, required this.lat, required this.lon, required this.visitors, required this.favorites, required this.corners, required this.offerType, required this.mainOfferImg});

}