import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapas_app/config/config.dart';
import 'package:mapas_app/infrastructure/infrastructure.dart';

class TrafficService {
  final Dio _dioTraffic;

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor());

  Future<TrafficResponse> getCoordsStartAndEnd(LatLng start, LatLng end) async {
    final coordString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseTrafficUrl/driving/$coordString';

    final resp = await _dioTraffic.get(url);

    final data = TrafficResponse.fromMap(resp.data);
    

    return data;
  }
}
