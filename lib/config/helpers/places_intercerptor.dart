import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
final accessToken =
    'pk.eyJ1IjoiYWxiaW5yayIsImEiOiJjbG45cDFieWIwODhyMm1vaGZvZndpZDFwIn0.I68-78B-Hu8hd4MKc2X6Ag';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token':accessToken,
      'language' : 'es',
    });
    super.onRequest(options, handler);
  }
}
