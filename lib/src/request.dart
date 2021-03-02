import 'dart:typed_data';
import 'dart:convert';

import 'package:api_utils/src/timeout.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:api_utils/src/api_logger.dart';
import 'package:api_utils/src/status_code.dart';
import 'package:api_utils/src/api_response.dart';

@visibleForTesting
void setHttpClientForTesting(http.Client client) {
  assert(client != null);
  _client = client;
}

http.Client _client = http.Client();

typedef FromJson<T> = T Function(Map<String, dynamic>);

/// Make a GET request with a json object response
Future<ApiResponse<T>> get<T>({
  @required String url,
  @required FromJson<T> fromJson,
  bool useFromJsonOnFailure = false,
  Map<String, String> headers,
  Duration timeout,
}) async {
  try {
    var requestFuture = _client.get(url, headers: headers);

    if (timeout != null) {
      requestFuture.timeout(timeout, onTimeout: () {
        throw ApiTimeoutException();
      });
    }

    var response = await requestFuture;
    return _handleResult('GET', url, response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    _onException('GET', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a GET request with a byte array response
Future<ApiResponse<Uint8List>> getByteArray(
    {@required String url, Map<String, String> headers}) async {
  try {
    var response = await _client.get(url, headers: headers);
    return _handleByteArrayResult('GET', url, response);
  } catch (e, stack) {
    _onException('GET', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a GET request with an json list response
Future<ApiResponse<List<T>>> getList<T>(
    {@required String url,
    @required FromJson<T> fromJson,
    Map<String, String> headers}) async {
  try {
    var response = await _client.get(url, headers: headers);
    return _handleListResult('GET', url, response, fromJson);
  } catch (e, stack) {
    _onException('GET', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a POST request sending a json object, with an optional json object
/// response
Future<ApiResponse<T>> post<T>(
    {@required String url,
    @required Map<String, dynamic> body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response =
        await _client.post(url, headers: headers, body: jsonEncode(body));
    return _handleResult('POST', url, response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    _onException('POST', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a POST request sending a raw string, with an optional json object
/// response
Future<ApiResponse<T>> postAsString<T>(
    {@required String url,
    @required String body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response = await _client.post(url, headers: headers, body: body);
    return _handleResult('POST', url, response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    _onException('POST', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a POST request sending a json object, with an optional json list
/// response
Future<ApiResponse<List<T>>> postAndGetList<T>(
    {@required String url,
    @required Map<String, dynamic> body,
    @required FromJson<T> fromJson,
    Map<String, String> headers}) async {
  try {
    var response =
        await _client.post(url, headers: headers, body: jsonEncode(body));
    return _handleListResult('POST', url, response, fromJson);
  } catch (e, stack) {
    _onException('POST', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a PUT request sending a json object, with an optional json object
/// response
Future<ApiResponse<T>> put<T>(
    {@required String url,
    @required Map<String, dynamic> body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response =
        await _client.put(url, headers: headers, body: jsonEncode(body));
    return _handleResult('PUT', url, response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    _onException('PUT', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a PUT request sending a json list, with an optional json object
/// response
Future<ApiResponse<T>> putList<T>(
    {@required String url,
    @required List body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response =
        await _client.put(url, headers: headers, body: jsonEncode(body));
    return _handleResult('PUT', url, response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    _onException('PUT', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a DELETE request
Future<ApiResponse<T>> delete<T>(
    {@required String url, Map<String, String> headers}) async {
  try {
    var response = await _client.delete(url, headers: headers);
    return _handleResult('DELETE', url, response, null, false);
  } catch (e, stack) {
    _onException('DELETE', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a PATCH request sending a json object, with an optional json object
/// response
Future<ApiResponse<T>> patch<T>(
    {@required String url,
    @required Map<String, dynamic> body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response =
        await _client.patch(url, headers: headers, body: jsonEncode(body));
    return _handleResult(
        'PATCH', url, response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    _onException('PATCH', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

ApiResponse<T> _handleResult<T>(
  String method,
  String url,
  http.Response response,
  T Function(Map<String, dynamic>) fromJson,
  bool useFromJsonOnFailure,
) {
  T data;
  if (isSuccessStatusCode(response.statusCode)) {
    if (fromJson != null) {
      data = fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    return ApiResponse<T>(response.statusCode, data: data);
  } else {
    if (fromJson != null && useFromJsonOnFailure) {
      data = fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    _onError(method, url, response.statusCode, response.body);
    return ApiResponse(response.statusCode, data: data, error: response.body);
  }
}

ApiResponse<Uint8List> _handleByteArrayResult(
  String method,
  String url,
  http.Response response,
) {
  Uint8List data;
  if (isSuccessStatusCode(response.statusCode)) {
    data = response.bodyBytes;
    return ApiResponse<Uint8List>(response.statusCode, data: data);
  } else {
    _onError(method, url, response.statusCode, response.body);
    return ApiResponse(response.statusCode, data: data, error: response.body);
  }
}

ApiResponse<List<T>> _handleListResult<T>(
  String method,
  String url,
  http.Response response,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (isSuccessStatusCode(response.statusCode)) {
    var list = json.decode(response.body) as Iterable;
    var data = list.map((x) => fromJson(x as Map<String, dynamic>)).toList();
    return ApiResponse<List<T>>(response.statusCode, data: data);
  } else {
    _onError(method, url, response.statusCode, response.body);
    return ApiResponse(response.statusCode, error: response.body);
  }
}

void _onException(
  String method,
  String url,
  int statusCode, [
  Exception e,
  StackTrace stack,
]) {
  var message = 'Api Error: $statusCode $method $url Error: ${e.toString()}';
  ApiLogger.onErrorMiddleware?.forEach((x) => {x(message, e, stack)});
}

void _onError(
  String method,
  String url,
  int statusCode,
  String error,
) {
  var message = 'Api Error: $statusCode $method $url Error: $error';
  ApiLogger.onErrorMiddleware?.forEach((x) => {x(message, null, null)});
}
