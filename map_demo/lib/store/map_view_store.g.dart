// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_view_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MapViewStore on _MapViewStore, Store {
  final _$routesAtom = Atom(name: '_MapViewStore.routes');

  @override
  List<LatLng> get routes {
    _$routesAtom.reportRead();
    return super.routes;
  }

  @override
  set routes(List<LatLng> value) {
    _$routesAtom.reportWrite(value, super.routes, () {
      super.routes = value;
    });
  }

  final _$currentRotateAtom = Atom(name: '_MapViewStore.currentRotate');

  @override
  double get currentRotate {
    _$currentRotateAtom.reportRead();
    return super.currentRotate;
  }

  @override
  set currentRotate(double value) {
    _$currentRotateAtom.reportWrite(value, super.currentRotate, () {
      super.currentRotate = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_MapViewStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$currentLocationAtom = Atom(name: '_MapViewStore.currentLocation');

  @override
  LatLng? get currentLocation {
    _$currentLocationAtom.reportRead();
    return super.currentLocation;
  }

  @override
  set currentLocation(LatLng? value) {
    _$currentLocationAtom.reportWrite(value, super.currentLocation, () {
      super.currentLocation = value;
    });
  }

  final _$cafeShopsAtom = Atom(name: '_MapViewStore.cafeShops');

  @override
  List<store_data.Store> get cafeShops {
    _$cafeShopsAtom.reportRead();
    return super.cafeShops;
  }

  @override
  set cafeShops(List<store_data.Store> value) {
    _$cafeShopsAtom.reportWrite(value, super.cafeShops, () {
      super.cafeShops = value;
    });
  }

  final _$fetchRouteAsyncAction = AsyncAction('_MapViewStore.fetchRoute');

  @override
  Future<dynamic> fetchRoute(LatLng start, LatLng end) {
    return _$fetchRouteAsyncAction.run(() => super.fetchRoute(start, end));
  }

  final _$getCurrentLocationAsyncAction =
      AsyncAction('_MapViewStore.getCurrentLocation');

  @override
  Future<dynamic> getCurrentLocation() {
    return _$getCurrentLocationAsyncAction
        .run(() => super.getCurrentLocation());
  }

  final _$loadCafeShopsAsyncAction = AsyncAction('_MapViewStore.loadCafeShops');

  @override
  Future<dynamic> loadCafeShops() {
    return _$loadCafeShopsAsyncAction.run(() => super.loadCafeShops());
  }

  @override
  String toString() {
    return '''
routes: ${routes},
currentRotate: ${currentRotate},
isLoading: ${isLoading},
currentLocation: ${currentLocation},
cafeShops: ${cafeShops}
    ''';
  }
}
