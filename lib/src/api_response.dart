import 'package:api_utils/src/status_code.dart';

/// Response from a web api, with a typed [data] field
class ApiResponse<T> {
  /// Http status code returned from the server
  final int statusCode;

  /// Only populated when the request fails for some reason. This value will
  /// contain an error response from the server or exception information if
  /// the request failed before getting a response.
  final String? error;

  /// If the request was successful
  bool get isSuccess => isSuccessStatusCode(statusCode);

  ApiResponse._(this.statusCode, {this.error});

  factory ApiResponse(statusCode, {T? data, error}) {
    if (isSuccessStatusCode(statusCode) && data != null) {
      return SuccessApiResponse<T>(statusCode: statusCode, data: data);
    }
    return FailureApiResponse<T>(statusCode: statusCode, error: error);
  }
}

/// Successful response from a web api, with a typed [data] field
class SuccessApiResponse<T> implements ApiResponse<T> {
  /// Http status code returned from the server
  final int statusCode;

  /// Response data transformed into a strongly typed object
  final T data;

  /// Only populated when the request fails for some reason. This value will
  /// contain an error response from the server or exception information if
  /// the request failed before getting a response.
  final String? error = null;

  /// If the request was successful
  bool get isSuccess => isSuccessStatusCode(statusCode);

  SuccessApiResponse({required this.statusCode, required this.data});
}

/// Unsuccessful response from a web api, with a typed [data] field
class FailureApiResponse<T> implements ApiResponse<T> {
  /// Http status code returned from the server
  final int statusCode;

  /// Only populated when the request fails for some reason. This value will
  /// contain an error response from the server or exception information if
  /// the request failed before getting a response.
  final String? error;

  /// If the request was successful
  bool get isSuccess => isSuccessStatusCode(statusCode);

  FailureApiResponse({required this.statusCode, required this.error});
}
