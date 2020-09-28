import 'dart:typed_data';

import 'package:api_utils/src/status_code.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:api_utils/src/api_response.dart';

typedef FromJson<T> = T Function(Map<String, dynamic>);

Future<ApiResponse<T>> get<T>(
    {@required String url,
    @required FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response = await http.get(url, headers: headers);
    return _handleResult(response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

Future<ApiResponse<Uint8List>> getByteArray(
    {@required String url, Map<String, String> headers}) async {
  try {
    var response = await http.get(url, headers: headers);
    return _handleByteArrayResult(response);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

Future<ApiResponse<List<T>>> getList<T>(
    {@required String url,
    @required FromJson<T> fromJson,
    Map<String, String> headers}) async {
  try {
    var response = await http.get(url, headers: headers);
    return _handleListResult(response, fromJson);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

Future<ApiResponse<T>> post<T>(
    {@required String url,
    @required Map<String, dynamic> body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return _handleResult(response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

Future<ApiResponse<T>> postAsString<T>(
    {@required String url,
    @required String body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response = await http.post(url, headers: headers, body: body);
    return _handleResult(response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

Future<ApiResponse<List<T>>> postAndGetList<T>(
    {@required String url,
    @required Map<String, dynamic> body,
    @required FromJson<T> fromJson,
    Map<String, String> headers}) async {
  try {
    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return _handleListResult(response, fromJson);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

Future<ApiResponse<T>> put<T>(
    {@required String url,
    @required Map<String, dynamic> body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response =
        await http.put(url, headers: headers, body: jsonEncode(body));
    return _handleResult(response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

Future<ApiResponse<T>> putList<T>(
    {@required String url,
    @required List body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response =
        await http.put(url, headers: headers, body: jsonEncode(body));
    return _handleResult(response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

Future<ApiResponse<T>> delete<T>(
    {@required String url, Map<String, String> headers}) async {
  try {
    var response = await http.delete(url, headers: headers);
    return _handleResult(response, null, false);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

Future<ApiResponse<T>> patch<T>(
    {@required String url,
    @required Map<String, dynamic> body,
    FromJson<T> fromJson,
    bool useFromJsonOnFailure = false,
    Map<String, String> headers}) async {
  try {
    var response =
        await http.patch(url, headers: headers, body: jsonEncode(body));
    return _handleResult(response, fromJson, useFromJsonOnFailure);
  } catch (e, stack) {
    // todo logger
    return ApiResponse(-1, error: e.toString());
  }
}

ApiResponse<T> _handleResult<T>(
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
    // todo logger
    return ApiResponse(response.statusCode, data: data, error: response.body);
  }
}

ApiResponse<Uint8List> _handleByteArrayResult(http.Response response) {
  Uint8List data;
  if (isSuccessStatusCode(response.statusCode)) {
    data = response.bodyBytes;
    return ApiResponse<Uint8List>(response.statusCode, data: data);
  } else {
    // todo logger
    return ApiResponse(response.statusCode, data: data, error: response.body);
  }
}

ApiResponse<List<T>> _handleListResult<T>(
    http.Response response, T Function(Map<String, dynamic>) fromJson) {
  if (isSuccessStatusCode(response.statusCode)) {
    var list = json.decode(response.body) as Iterable;
    var data = list.map((x) => fromJson(x as Map<String, dynamic>)).toList();
    return ApiResponse<List<T>>(response.statusCode, data: data);
  } else {
    // todo logger
    return ApiResponse(response.statusCode, error: response.body);
  }
}
