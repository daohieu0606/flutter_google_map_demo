import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_demo/data/place.dart';
import 'package:http/http.dart' as http;

class GeoService {
  static const String accessToken =
      "pk.eyJ1IjoiZGFvaGlldTA2MDYiLCJhIjoiY2xiOTUxcHI4MHJkeTN2bzNzZXA0bDlociJ9.0RfCuyaCgZemzo0V4CwwAg";

  static const mapTitleServer =
      'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token=${GeoService.accessToken}';

  static Future<List<Place>?> getPlaces(String searchKey) async {
    String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$searchKey.json?access_token=$accessToken";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> features = jsonDecode(response.body)['features'];
      var res = features.map((e) => Place.fromJson(e)).toList();

      return res;
    } else {}

    return null;
  }

  static Future<List<LatLng>?> getRoutes(LatLng start, LatLng end) async {
    String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox/cycling';
    String url =
        "$baseUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson&access_token=$accessToken";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['routes'][0];
      List<dynamic>? routes = data['geometry']['coordinates'];

      if (routes == null || routes.isEmpty) return null;

      var res = routes.map((e) => LatLng(e[1], e[0])).toList();

      return res;
    } else {}

    return null;
  }
}
