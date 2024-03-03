import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/config/config.dart';
import 'package:mapas_app/domain/domain.dart';
import 'package:mapas_app/presentation/blocs/blocs.dart';
part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserEvent>(
      (event, emit) => emit(state.copyWith(isfollowingUser: false)),
    );
    on<UpdateUserPolylinesEvent>(_onPolylineNewPoint);
    on<OnToggleUserRoute>((event, emit) {
      emit(state.copyWith(showMyRoute: !state.showMyRoute));
    });
    //DisplayPolylinesEvent
    on<DisplayPolylinesEvent>((event, emit) {
      emit(state.copyWith(polylines: event.polylines, markers: event.markers));
    });

    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnownLocation != null) {
        add(UpdateUserPolylinesEvent(locationState.mylocationHistory));
      }

      if (!state.isfollowingUser) return;
      if (locationState.lastKnownLocation == null) return;
      moveCamera(locationState.lastKnownLocation!);
    });
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.mapController;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isfollowingUser: true));
    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylinesEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations,
    );
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;

    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async {
    final myRouter = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 5,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    double kms = double.parse(destination.distance) / 1000; //todo:tratar de observar
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    double tripDuration = (double.parse(destination.duration) / 60).floorToDouble();  

    //Custom Markers
    // final startMaker = await getAssetImageMarker();
    // final endMaker = await getNetworkImageMarker(); 

    final startMaker = await getStarCustomMarker(tripDuration.toInt(), 'Mi ubicacion');
    final endMaker = await getEndCustomMarker(kms.toInt(), destination.endPlace.placeName);


    final starMarker = Marker(
      anchor: const Offset(0.1, 1),
      markerId: const MarkerId('start'),
      position: destination.points.first,
      icon: startMaker,
      // infoWindow:  InfoWindow(
      //   title: 'Inicio',
      //   snippet: 'Kms $kms, Duración: $tripDuration minutos'
      // ),
    );

    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: endMaker,
      // anchor: const Offset(0, 0),
      // infoWindow:  InfoWindow(
      //   title: destination.endPlace.text,
      //   snippet: destination.endPlace.placeName,
      // ),
    );

    final curretPolylines = Map<String, Polyline>.from(state.polylines);
    curretPolylines['route'] = myRouter;

    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = starMarker;
    currentMarkers['end'] = endMarker;

    add(DisplayPolylinesEvent(curretPolylines, currentMarkers));

    // await Future.delayed(const Duration(milliseconds: 300));
    // _mapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
