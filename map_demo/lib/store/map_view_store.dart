import 'package:flutter/cupertino.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_demo/service/geo_service.dart';
import 'package:mobx/mobx.dart';

part 'map_view_store.g.dart';

class MapViewStore = _MapViewStore with _$MapViewStore;

abstract class _MapViewStore with Store {
  @observable
  List<LatLng> routes = List.empty();

  @observable
  double currentRotate = 0;

  @observable
  bool isLoading = false;

  @action
  Future fetchRoute(LatLng start, LatLng end, Function onFinished) async {
    isLoading = true;

    GeoService.getRoutes(start, end).then((value) {
      routes = value ?? List.empty();

      isLoading = false;

      onFinished.call();
    });
  }

  LatLngBounds? getBounds() {
    if (routes == null || routes.length < 2) return null;

    double minLat = routes
        .reduce((value, element) =>
            value.latitude < element.latitude ? value : element)
        .latitude;

    double minLng = routes
        .reduce((value, element) =>
            value.longitude < element.longitude ? value : element)
        .longitude;

    double maxLat = routes
        .reduce((value, element) =>
            value.latitude > element.latitude ? value : element)
        .latitude;

    double maxLng = routes
        .reduce((value, element) =>
            value.longitude > element.longitude ? value : element)
        .longitude;

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }
}
