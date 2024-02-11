part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUSer;
  final LatLng? lastKnownLocation;
  final List<LatLng> mylocationHistory;

  //ultimo geolocation
  //historia
  const LocationState(
      {this.followingUSer = false, this.lastKnownLocation, mylocationHistory})
      : mylocationHistory = mylocationHistory ?? const [];

  LocationState copyWith({
    bool? followingUSer,
    LatLng? lastKnownLocation,
    List<LatLng>? mylocationHistory,
  }) =>
      LocationState(
        followingUSer: followingUSer ?? this.followingUSer,
        lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
        mylocationHistory: mylocationHistory ?? this.mylocationHistory,
      );

  @override
  List<Object?> get props =>
      [followingUSer, lastKnownLocation, mylocationHistory];
}
