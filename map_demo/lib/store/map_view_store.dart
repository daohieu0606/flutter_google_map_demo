import 'package:flutter/cupertino.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_demo/service/geo_service.dart';
import 'package:map_demo/utils/store_utils.dart';
import 'package:mobx/mobx.dart';
import 'package:map_demo/data/store.dart' as store_data;

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
  Future fetchRoute(LatLng start, LatLng end) async {
    isLoading = true;

    List<LatLng>? res = await GeoService.getRoutes(start, end);

    routes = res ?? List.empty();

    isLoading = false;
  }

  LatLngBounds? getBounds() {
    if (routes.length < 2) return null;

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

  //current device location
  @observable
  LatLng? currentLocation;

  @action
  Future getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentLocation = LatLng(position.latitude, position.longitude);
  }

  //store-------------------------------------------------
  @observable
  List<store_data.Store> cafeShops = List.empty();

  @action
  Future loadCafeShops() async {
    cafeShops = StoreUtils.getCafeShops();
  }
}
