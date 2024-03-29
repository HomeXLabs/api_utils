import 'dart:convert';
import 'dart:typed_data';

import 'package:api_utils/src/api_config.dart';
import 'package:api_utils/src/api_response.dart';
import 'package:api_utils/src/status_code.dart';
import 'package:api_utils/src/timeout.dart';
import 'package:http/http.dart' as http;

void setHttpClient(http.Client client) {
  _client = client;
}

http.Client _client = http.Client();

const Map<String, String> _defaultHeaders = {
  'Content-Type': 'application/json'
};

typedef FromJson<T> = T Function(Map<String, dynamic>);
typedef GetHeaders = Future<Map<String, String>> Function();

/// Make a GET request with a json object response
Future<ApiResponse<T>> get<T>({
  required String url,
  required FromJson<T> fromJson,
  bool useFromJsonOnFailure = false,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture = _client.get(Uri.parse(url), headers: _headers);
    var response = await _makeRequest(requestFuture, timeout);
    return _handleResult('GET', url, response, fromJson, useFromJsonOnFailure);
  } on Exception catch (e, stack) {
    _onException('GET', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a GET request with a byte array response
Future<ApiResponse<Uint8List>> getByteArray({
  required String url,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture = _client.get(Uri.parse(url), headers: _headers);
    var response = await _makeRequest(requestFuture, timeout);
    return _handleByteArrayResult('GET', url, response);
  } on Exception catch (e, stack) {
    _onException('GET', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a GET request with an json list response
Future<ApiResponse<List<T>>> getList<T>({
  required String url,
  required FromJson<T> fromJson,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture = _client.get(Uri.parse(url), headers: _headers);
    var response = await _makeRequest(requestFuture, timeout);
    return _handleListResult('GET', url, response, fromJson);
  } on Exception catch (e, stack) {
    _onException('GET', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a POST request sending a json object, with an optional json object
/// response
Future<ApiResponse<T>> post<T>({
  required String url,
  required Map<String, dynamic> body,
  FromJson<T>? fromJson,
  bool useFromJsonOnFailure = false,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture =
        _client.post(Uri.parse(url), headers: _headers, body: jsonEncode(body));
    var response = await _makeRequest(requestFuture, timeout);
    return _handleResult('POST', url, response, fromJson, useFromJsonOnFailure);
  } on Exception catch (e, stack) {
    _onException('POST', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a POST request sending a raw string, with an optional json object
/// response
Future<ApiResponse<T>> postAsString<T>({
  required String url,
  required String body,
  FromJson<T>? fromJson,
  bool useFromJsonOnFailure = false,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture =
        _client.post(Uri.parse(url), headers: _headers, body: body);
    var response = await _makeRequest(requestFuture, timeout);
    return _handleResult('POST', url, response, fromJson, useFromJsonOnFailure);
  } on Exception catch (e, stack) {
    _onException('POST', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a POST request sending a json object, with an optional json list
/// response
Future<ApiResponse<List<T>>> postAndGetList<T>({
  required String url,
  required Map<String, dynamic> body,
  required FromJson<T> fromJson,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture =
        _client.post(Uri.parse(url), headers: _headers, body: jsonEncode(body));
    var response = await _makeRequest(requestFuture, timeout);
    return _handleListResult('POST', url, response, fromJson);
  } on Exception catch (e, stack) {
    _onException('POST', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a PUT request sending a json object, with an optional json object
/// response
Future<ApiResponse<T>> put<T>({
  required String url,
  required Map<String, dynamic> body,
  FromJson<T>? fromJson,
  bool useFromJsonOnFailure = false,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture =
        _client.put(Uri.parse(url), headers: _headers, body: jsonEncode(body));
    var response = await _makeRequest(requestFuture, timeout);
    return _handleResult('PUT', url, response, fromJson, useFromJsonOnFailure);
  } on Exception catch (e, stack) {
    _onException('PUT', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a PUT request sending a json list, with an optional json object
/// response
Future<ApiResponse<T>> putList<T>({
  required String url,
  required List body,
  FromJson<T>? fromJson,
  bool useFromJsonOnFailure = false,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture =
        _client.put(Uri.parse(url), headers: _headers, body: jsonEncode(body));
    var response = await _makeRequest(requestFuture, timeout);
    return _handleResult('PUT', url, response, fromJson, useFromJsonOnFailure);
  } on Exception catch (e, stack) {
    _onException('PUT', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a DELETE request
Future<ApiResponse<T>> delete<T>({
  required String url,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture = _client.delete(Uri.parse(url), headers: _headers);
    var response = await _makeRequest(requestFuture, timeout);
    return _handleResult('DELETE', url, response, null, false);
  } on Exception catch (e, stack) {
    _onException('DELETE', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

/// Make a PATCH request sending a json object, with an optional json object
/// response
Future<ApiResponse<T>> patch<T>({
  required String url,
  required Map<String, dynamic> body,
  FromJson<T>? fromJson,
  bool useFromJsonOnFailure = false,
  GetHeaders? headers,
  Duration? timeout,
}) async {
  try {
    var _headers = headers != null ? await headers() : _defaultHeaders;
    var requestFuture = _client.patch(Uri.parse(url),
        headers: _headers, body: jsonEncode(body));
    var response = await _makeRequest(requestFuture, timeout);
    return _handleResult(
        'PATCH', url, response, fromJson, useFromJsonOnFailure);
  } on Exception catch (e, stack) {
    _onException('PATCH', url, -1, e, stack);
    return ApiResponse(-1, error: e.toString());
  }
}

ApiResponse<T> _handleResult<T>(
  String method,
  String url,
  http.Response response,
  T Function(Map<String, dynamic>)? fromJson,
  bool useFromJsonOnFailure,
) {
  T? data;
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
  if (isSuccessStatusCode(response.statusCode)) {
    return ApiResponse<Uint8List>(response.statusCode,
        data: response.bodyBytes);
  } else {
    _onError(method, url, response.statusCode, response.body);
    return ApiResponse(response.statusCode,
        data: response.bodyBytes, error: response.body);
  }
}

ApiResponse<List<T>> _handleListResult<T>(
  String method,
  String url,
  http.Response response,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (isSuccessStatusCode(response.statusCode)) {
    final list = json.decode(response.body) as Iterable;
    final data = list.map((x) => fromJson(x as Map<String, dynamic>)).toList();
    return ApiResponse<List<T>>(response.statusCode, data: data);
  } else {
    _onError(method, url, response.statusCode, response.body);
    return ApiResponse(response.statusCode, error: response.body);
  }
}

// if a per request timeout or global timeout is set, timeout the future when
// it is created.
Future<http.Response> _makeRequest(
  Future<http.Response> requestFuture,
  Duration? timeout,
) async {
  http.Response response;

  // Prefer per request timeout over the global timeout
  var _timeout = timeout ?? ApiUtilsConfig.timeout;
  if (_timeout != null) {
    response = await requestFuture.timeout(
      _timeout,
      onTimeout: () {
        throw ApiTimeoutException();
      },
    );
  } else {
    response = await requestFuture;
  }
  return response;
}

void _onException(
  String method,
  String url,
  int statusCode, [
  Exception? e,
  StackTrace? stack,
]) {
  var message = 'Api Error: $statusCode $method $url Error: ${e.toString()}';
  ApiUtilsConfig.onErrorMiddleware.forEach((x) => {x(message, e, stack)});
}

void _onError(
  String method,
  String url,
  int statusCode,
  String error,
) {
  var message = 'Api Error: $statusCode $method $url Error: $error';
  ApiUtilsConfig.onErrorMiddleware.forEach((x) => {x(message, null, null)});
}
