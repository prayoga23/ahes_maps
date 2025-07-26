import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../helpers/dio_exceptions.dart';

final String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
final String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
final String navType = 'cycling';

final Dio _dio = Dio();

Future<Map<String, dynamic>> getCyclingRouteUsingMapbox(
    Point source, Point destination) async {
  final String url =
      '$baseUrl/$navType/${source.coordinates[0]},${source.coordinates[1]};'
      '${destination.coordinates[0]},${destination.coordinates[1]}'
      '?alternatives=true&continue_straight=true&geometries=geojson&language=en'
      '&overview=full&steps=true&access_token=$accessToken';

  try {
    _dio.options.contentType = Headers.jsonContentType;
    final response = await _dio.get(url);
    return response.data;
  } catch (e) {
    final errorMessage =
        DioExceptions.fromDioError(e as DioException).toString();
    debugPrint(errorMessage);
    return {};
  }
}
