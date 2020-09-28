import 'package:api_utils/src/status_code.dart';

class ApiResponse<T> {
  final int statusCode;
  final T data;
  final String error;

  bool get isSuccess => isSuccessStatusCode(statusCode);

  ApiResponse(this.statusCode, {this.data, this.error});
}
