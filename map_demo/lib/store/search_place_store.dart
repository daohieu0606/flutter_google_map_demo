import 'package:map_demo/data/place.dart';
import 'package:map_demo/service/geo_service.dart';
import 'package:mobx/mobx.dart';

part 'search_place_store.g.dart';

class SearchPlaceStore = _SearchPlaceStore with _$SearchPlaceStore;

abstract class _SearchPlaceStore with Store {
  @observable
  bool openSearchView = false;

  @observable
  bool isSearching = false;

  @observable
  bool isLoading = false;

  @observable
  List<Place>? places;

  @action
  Future fetchPlaces(String keyWord) async {
    isLoading = true;

    await Future.delayed(const Duration(milliseconds: 500));

    GeoService.getPlaces(keyWord).then((value) {
      places = value;
      isLoading = false;
    });
  }
}
