import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_demo/constant/images_key.dart';
import 'package:map_demo/data/place.dart';
import 'package:map_demo/data/store.dart';
import 'package:map_demo/store/map_view_store.dart';
import 'package:map_demo/ui/search_place_view.dart';
import 'package:provider/provider.dart';

import '../service/geo_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapController = MapController();

  //layers---------------------------------------------------
  final _userLocationLayer =
      MarkerLayerOptions(markers: List.empty(growable: true));

  //view
  late SearchPlaceView _searchView;

  //store
  final _mapViewStore = MapViewStore();

  double _rotation = 0.0;

  final List<Marker> _popupCafeShopMarkers = List.empty(growable: true);

  @override
  void initState() {
    _searchView = SearchPlaceView(
      onPlaceSelected: (place) {
        _getAndDrawRouteLines(place);
      },
    );

    _fetchCurrentLocation();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _mapViewStore.loadCafeShops();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MapViewStore>(create: (context) => _mapViewStore),
      ],
      child: Scaffold(
        body: Observer(
          builder: (context) {
            return Stack(
              children: [
                _mapView(),
                _searchView,
                _optionalBtns(),
                _loadingView(),
              ],
            );
          },
        ),
      ),
    );
  }

  _optionalBtns() {
    return Positioned(
      bottom: 24,
      right: 24,
      child: Column(
        children: [
          _btnCompass(),
          const SizedBox(height: 8),
          _btnMoveToUserLocation()
        ],
      ),
    );
  }

  Transform _btnCompass() {
    return Transform.rotate(
      angle: _rotation * 3.14 / 180,
      child: FloatingActionButton(
        onPressed: () {
          _mapController.rotate(0);
          setState(() {
            _rotation = 0;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Image.asset(ImagesKey.ic_compass),
        ),
      ),
    );
  }

  _loadingView() {
    return Visibility(
      visible: _mapViewStore.isLoading,
      child: Container(
        color: Colors.black12.withOpacity(0.3),
        child: const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: Colors.green,
              strokeWidth: 6,
            ),
          ),
        ),
      ),
    );
  }

  FlutterMap _mapView() {
    return FlutterMap(
      mapController: _mapController,
      options: _mapOptions(),
      layers: [
        _onlMapLayer(),
        _routeLayer(),
        _routeLayer2(),
        _userLocationLayer,
        _cafeShopsLayer(),
        _cafeShopePopupLayer(),
      ],
    );
  }

  _onlMapLayer() {
    return TileLayerOptions(
      tileProvider: NetworkTileProvider(),
      urlTemplate: GeoService.mapTitleServer,
      maxZoom: 25,
    );
  }

  _routeLayer() {
    return PolylineLayerOptions(
      polylines: [
        Polyline(
          points: _mapViewStore.routes,
          strokeWidth: 6,
        ),
      ],
    );
  }

  _cafeShopsLayer() {
    return MarkerLayerOptions(
      markers: _mapViewStore.cafeShops
          .map(
            (e) => _cafeShopMarker(e),
          )
          .toList(),
    );
  }

  _mapOptions() {
    return MapOptions(
      center: LatLng(10.8231, 106.6297),
      zoom: 24,
      onTap: (position, latlng) {
        debugPrint('lat: ${latlng.latitude}, lng: ${latlng.longitude},');
        _searchView.hide();
        _removeAllCafeShopPopupMarkers();
      },
      onPositionChanged: (position, _) {
        try {
          setState(() {
            _rotation = _mapController.rotation;
          });
        } catch (e) {
          //do nothing
        }
      },
    );
  }

  _routeLayer2() {
    return MarkerLayerOptions(
      markers: _mapViewStore.routes
          .map(
            (e) => Marker(
              height: 9,
              width: 9,
              point: e,
              builder: (context) {
                return SvgPicture.asset(ImagesKey.ic_coordinate_marker);
              },
            ),
          )
          .toList(),
    );
  }

  FloatingActionButton _btnMoveToUserLocation() {
    return FloatingActionButton(
      onPressed: () {
        _searchView.hide();
        _moveToCurrentLocation();
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          ImagesKey.ic_get_last_known_location,
          color: Colors.white,
        ),
      ),
    );
  }

  void _fetchCurrentLocation() {
    _mapViewStore.getCurrentLocation().then((value) {
      _mapController.move(_mapViewStore.currentLocation!, 18);
      _addUserMarker();
    });
  }

  _addUserMarker() {
    _userLocationLayer.markers
      ..clear()
      ..add(
        Marker(
          point: _mapViewStore.currentLocation!,
          builder: (context) {
            return SvgPicture.asset(
              ImagesKey.ic_current_location,
            );
          },
        ),
      );
  }

  void _moveToCurrentLocation() {
    if (_mapViewStore.currentLocation == null) return;

    _mapController.move(_mapViewStore.currentLocation!, 18);
  }

  void _getAndDrawRouteLines(Place place) {
    _mapViewStore
        .fetchRoute(
      _mapViewStore.currentLocation!,
      LatLng(
        place.center![1],
        place.center![0],
      ),
    )
        .then(
      (value) {
        _mapController.rotate(0);

        _userLocationLayer.markers.clear();

        _addUserMarker();

        _addDestinationMarker(_mapViewStore.routes.last);

        _mapController.fitBounds(
          _mapViewStore.getBounds()!,
          options: const FitBoundsOptions(
            padding: EdgeInsets.symmetric(horizontal: 40),
          ),
        );
      },
    );
  }

  void _drawRouteLineToCafeShop(Place place) {
    _mapViewStore
        .fetchRoute(
      _mapViewStore.currentLocation!,
      LatLng(place.center![1], place.center![0]),
    )
        .then((value) {
      _mapController.rotate(0);

      _userLocationLayer.markers.clear();

      _addUserMarker();

      _mapController.fitBounds(
        _mapViewStore.getBounds()!,
        options: const FitBoundsOptions(
          padding: EdgeInsets.symmetric(horizontal: 40),
        ),
      );
    });
  }

  _addDestinationMarker(LatLng latLng) {
    _userLocationLayer.markers.add(
      Marker(
        height: 76,
        width: 58,
        anchorPos: AnchorPos.align(AnchorAlign.center),
        point: latLng,
        builder: (context) {
          return Transform.rotate(
            angle: -_rotation * 3.14 / 180,
            child: Container(
              margin: const EdgeInsets.only(left: 4, bottom: 38),
              child: Image.asset(
                ImagesKey.ic_destination,
              ),
            ),
          );
        },
      ),
    );
  }

  Marker _cafeShopMarker(Store e) {
    return Marker(
      height: 80,
      width: 44,
      point: LatLng(e.lat!, e.lng!),
      builder: (context) {
        return Transform.rotate(
          angle: -_rotation * 3.14 / 180,
          child: GestureDetector(
            onTap: () {
              _showCafeShopPopupMarker(e);
            },
            child: Image.asset(
              ImagesKey.ic_cafe_shop_marker,
            ),
          ),
        );
      },
    );
  }

  _cafeShopePopupLayer() {
    return PopupMarkerLayerOptions(
      markerRotateAlignment:
          PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.center),
      markers: _popupCafeShopMarkers,
    );
  }

  Marker _cafeShopPopupMarker(Store e) {
    return Marker(
      width: 180,
      height: 410,
      point: LatLng(e.lat!, e.lng!),
      builder: (context) {
        return GestureDetector(
          onTap: () {
            _drawRouteLineToCafeShop(Place(center: [e.lng!, e.lat!]));
            _removeAllCafeShopPopupMarkers();
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 230),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    e.image!,
                    width: 180,
                    height: 82,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.name!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          e.address!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                        ),
                        Text(
                          e.openHours!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCafeShopPopupMarker(Store e) {
    setState(() {
      _popupCafeShopMarkers.clear();
      _popupCafeShopMarkers.add(_cafeShopPopupMarker(e));
    });
  }

  void _removeAllCafeShopPopupMarkers() {
    setState(() {
      _popupCafeShopMarkers.clear();
    });
  }
}
