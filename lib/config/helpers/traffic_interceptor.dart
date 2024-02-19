import 'package:dio/dio.dart';

const accessToken =
    'pk.eyJ1IjoiYWxiaW5yayIsImEiOiJjbG45cDFieWIwODhyMm1vaGZvZndpZDFwIn0.I68-78B-Hu8hd4MKc2X6Ag';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token':accessToken,

    });
    super.onRequest(options, handler);
  }
}
