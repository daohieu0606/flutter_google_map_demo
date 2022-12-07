import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_demo/constant/images_key.dart';
import 'package:map_demo/data/place.dart';
import 'package:map_demo/store/map_view_store.dart';
import 'package:map_demo/ui/search_place_view.dart';
import 'package:map_demo/utils/view_utils.dart';
import 'package:provider/provider.dart';

import '../service/geo_service.dart';

class MapPage extends StatefulWidget {
  static const mapTitleServer =
      'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGFvaGlldTA2MDYiLCJhIjoiY2xiOTUxcHI4MHJkeTN2bzNzZXA0bDlociJ9.0RfCuyaCgZemzo0V4CwwAg';

  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? currentLocation;
  final _mapController = MapController();

  //layers---------------------------------------------------
  final _onlMapLayer = TileLayerOptions(
    tileProvider: NetworkTileProvider(),
    urlTemplate: MapPage.mapTitleServer,
    maxZoom: 25,
    // subdomains: ['0', '1', '2', '3'],
  );

  final _userLocationLayer =
      MarkerLayerOptions(markers: List.empty(growable: true));

  //view
  late SearchPlaceView _searchView;

  //store
  final _mapViewStore = MapViewStore();

  double _rotation = 0.0;

  @override
  void initState() {
    _searchView = SearchPlaceView(
      onPlaceSelected: (place) {
        _drawRouteLines(place);
      },
    );

    _fetchCurrentLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MapViewStore>(create: (context) => _mapViewStore),
      ],
      child: Scaffold(
        body: Observer(builder: (context) {
          return Stack(
            children: [
              _mapView(),
              _searchView,
              _loadingView(),
            ],
          );
        }),
        floatingActionButton: _btnMoveToUserLocation(),
      ),
    );
  }

  _loadingView() {
    return Visibility(
      visible: _mapViewStore.isLoading,
      child: Container(
        color: Colors.black12.withOpacity(0.4),
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
        _onlMapLayer,
        _routeLayer(),
        _routeLayer2(),
        _userLocationLayer,
      ],
    );
  }

  _mapOptions() {
    return MapOptions(
      center: LatLng(10.8231, 106.6297),
      zoom: 24,
      onTap: (position, latlng) {
        _searchView.hide();
      },
      onPositionChanged: (position, _) {
        try {
          setState(() {
            _rotation = _mapController.rotation;
          });
        } catch (e) {
          //do nothin
        }
      },
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

  _routeLayer2() {
    return MarkerLayerOptions(
      markers: _mapViewStore.routes
          .map(
            (e) => Marker(
              height: 8,
              width: 8,
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

  void _fetchCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentLocation = LatLng(position.latitude, position.longitude);

    _mapController.move(currentLocation!, 18);

    _addUserMarker();
  }

  _addUserMarker() {
    _userLocationLayer.markers.add(
      Marker(
        point: currentLocation!,
        builder: (context) {
          return SvgPicture.asset(
            ImagesKey.ic_current_location,
          );
        },
      ),
    );
  }

  void _moveToCurrentLocation() {
    if (currentLocation == null) return;

    _mapController.move(currentLocation!, 18);
  }

  void _drawRouteLines(Place place) {
    _mapViewStore.fetchRoute(
      currentLocation!,
      LatLng(place.center![1], place.center![0]),
      () {
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
}
