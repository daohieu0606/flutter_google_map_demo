import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:map_demo/data/place.dart';
import 'package:provider/provider.dart';

import '../store/search_place_store.dart';

class SearchPlaceView extends StatefulWidget {
  final _state = _SearchPlaceViewState();

  Function(Place place) onPlaceSelected;

  SearchPlaceView({
    Key? key,
    required this.onPlaceSelected,
  }) : super(key: key);

  @override
  State<SearchPlaceView> createState() => _state;

  void hide() {
    _state._hideSearch();
  }
}

class _SearchPlaceViewState extends State<SearchPlaceView> {
  final _edtController = TextEditingController();

  final _store = SearchPlaceStore();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SearchPlaceStore>(create: (ctx) => _store),
      ],
      child: Observer(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _edtSearch(),
            _searchResultView(),
          ],
        );
      }),
    );
  }

  _hideSearch() {
    FocusScope.of(context).unfocus();
    _store.isSearching = false;
  }

  _searchResultView() {
    return Visibility(
      visible: _store.isSearching,
      child: Container(
        margin: const EdgeInsets.only(top: 6, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: _store.isLoading ? _loadingSearchView() : _listSearchResult(),
      ),
    );
  }

  _loadingSearchView() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _edtSearch() {
    return Container(
      margin: const EdgeInsets.only(top: 54, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        controller: _edtController,
        onTap: () {
          _store.isSearching = true;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.location_on_outlined),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              String searchKey = _edtController.text;
              if (searchKey.isEmpty) return;

              _store.fetchPlaces(searchKey);
            },
            child: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  _listSearchResult() {
    return _store.places == null || _store.places!.isEmpty
        ? _emptyListView()
        : _havePlaceListView();
  }

  _havePlaceListView() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        minWidth: double.infinity,
        maxHeight: 400,
      ),
      child: ListView.builder(
        itemCount: _store.places!.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, position) {
          Place place = _store.places![position];

          return _itemViewPlace(place);
        },
      ),
    );
  }

  _itemViewPlace(Place place) {
    return GestureDetector(
      onTap: () {
        _hideSearch();
        widget.onPlaceSelected.call(place);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              place.text ?? 'Unknown',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(place.place_name ?? 'Unknown'),
            const SizedBox(
              height: 4,
            ),
            const Divider(
              thickness: 0.2,
              color: Colors.blueGrey,
            )
          ],
        ),
      ),
    );
  }

  _emptyListView() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: Center(
        child: Text('Không tìm thấy kết quả'),
      ),
    );
  }
}
