// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_place_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SearchPlaceStore on _SearchPlaceStore, Store {
  final _$openSearchViewAtom = Atom(name: '_SearchPlaceStore.openSearchView');

  @override
  bool get openSearchView {
    _$openSearchViewAtom.reportRead();
    return super.openSearchView;
  }

  @override
  set openSearchView(bool value) {
    _$openSearchViewAtom.reportWrite(value, super.openSearchView, () {
      super.openSearchView = value;
    });
  }

  final _$isSearchingAtom = Atom(name: '_SearchPlaceStore.isSearching');

  @override
  bool get isSearching {
    _$isSearchingAtom.reportRead();
    return super.isSearching;
  }

  @override
  set isSearching(bool value) {
    _$isSearchingAtom.reportWrite(value, super.isSearching, () {
      super.isSearching = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_SearchPlaceStore.isLoading');

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

  final _$placesAtom = Atom(name: '_SearchPlaceStore.places');

  @override
  List<Place>? get places {
    _$placesAtom.reportRead();
    return super.places;
  }

  @override
  set places(List<Place>? value) {
    _$placesAtom.reportWrite(value, super.places, () {
      super.places = value;
    });
  }

  final _$fetchPlacesAsyncAction = AsyncAction('_SearchPlaceStore.fetchPlaces');

  @override
  Future<dynamic> fetchPlaces(String keyWord) {
    return _$fetchPlacesAsyncAction.run(() => super.fetchPlaces(keyWord));
  }

  @override
  String toString() {
    return '''
openSearchView: ${openSearchView},
isSearching: ${isSearching},
isLoading: ${isLoading},
places: ${places}
    ''';
  }
}
