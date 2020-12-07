import 'package:api_utils/src/status_code.dart';

/// Response from a web api, with a typed [data] field
class ApiResponse<T> {
  /// Http status code returned from the server
  final int statusCode;

  /// Response data transformed into a strongly typed object
  final T? data;

  /// Only populated when the request fails for some reason. This value will
  /// contain an error response from the server or exception information if
  /// the request failed before getting a response.
  final String? error;

  /// If the request was successful
  bool get isSuccess => isSuccessStatusCode(statusCode);

  ApiResponse(this.statusCode, {this.data, this.error});
}
