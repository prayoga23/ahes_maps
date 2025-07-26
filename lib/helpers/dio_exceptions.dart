import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = "Request dibatalkan";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Koneksi timeout";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Timeout menerima data";
        break;
      case DioExceptionType.sendTimeout:
        message = "Timeout mengirim data";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
        break;
      case DioExceptionType.unknown:
        if (dioException.message?.contains("SocketException") ?? false) {
          message = "Tidak ada koneksi internet";
          break;
        }
        message = "Terjadi kesalahan yang tidak diketahui";
        break;
      default:
        message = "Ada yang tidak beres";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
