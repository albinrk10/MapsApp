import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/domain/domain.dart';
import '../blocs/blocs.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate() : super(searchFieldLabel: 'Buscar...');
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          final result = SearchResult(cancel: true);
          close(context, result);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    final serachBloc = BlocProvider.of<SearchBloc>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnownLocation!;

    serachBloc.getPlacesByQuery(proximity, query);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return ListView.separated(
            itemCount: places.length,
            separatorBuilder: (context, i) => const Divider(),
            itemBuilder: (context, i) {
              final place = places[i];
              return ListTile(
                leading: const Icon(
                  Icons.place_outlined,
                  color: Colors.black,
                ),
                title: Text(place.text),
                subtitle: Text(place.placeName),
                onTap: () {
                  final result = SearchResult(
                      cancel: false,
                      manual: false,
                      position: LatLng(place.center[1], place.center[0]),
                      name: place.placeName,
                      description: place.text);
                  serachBloc.add(AddToHistoryEvent(place));
                  close(context, result);

                },
              );
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final  history = BlocProvider.of<SearchBloc>(context).state.history;

    return ListView(
      children: [
        ListTile(
          leading: const Icon(
            Icons.location_on,
            color: Colors.black,
          ),
          title: const Text(
            'Colocar ubicacion manualmente',
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        ),
        //Construir la lista de elementos
        ...history.map((place) => ListTile(
              leading: const Icon(
                Icons.history,
                color: Colors.black,
              ),
              title: Text(place.text),
              subtitle: Text(place.placeName),
              onTap: () {
                final result = SearchResult(
                    cancel: false,
                    manual: false,
                    position: LatLng(place.center[1], place.center[0]),
                    name: place.placeName,
                    description: place.text);
                close(context, result);
              },
            ))
        

      ],
    );
  }
}
