import 'package:api_utils/src/status_code.dart';

/// Response from an api, with a typed [data] field
class ApiResponse<T> {
  final int statusCode;
  final T data;
  final String error;

  bool get isSuccess => isSuccessStatusCode(statusCode);

  ApiResponse(this.statusCode, {this.data, this.error});
}
