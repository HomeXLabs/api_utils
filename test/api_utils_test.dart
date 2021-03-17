import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:api_utils/api_utils.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  setUpAll(() {
    setHttpClientForTesting(MockClient((request) async {
      if (request.url.toString() ==
              'https://jsonplaceholder.typicode.com/posts' &&
          request.method == 'GET') {
        return http.Response(
            jsonEncode([
              Post(title: 'title', body: 'body'),
              Post(title: 'title', body: 'body'),
            ]),
            200);
      } else if (request.url.toString() ==
              'https://jsonplaceholder.typicode.com/posts' &&
          request.method == 'POST') {
        return http.Response('', 201);
      } else if (request.url.toString() ==
          'https://jsonplaceholder.typicode.com/posts-bad-url') {
        return http.Response('', 404);
      } else {
        throw Exception('Unknown mocked http request');
      }
    }));
  });

  test('getList', () async {
    var response = await getList(
        url: 'https://jsonplaceholder.typicode.com/posts',
        fromJson: (x) => Post.fromJson(x));

    expect(response.statusCode, 200);
    expect(response.isSuccess, true);
    expect(response.data != null, true);
  });

  test('ApiLogger logs', () async {
    String errorMsg = '';
    ApiUtilsConfig.onErrorMiddleware.add((message, e, stack) {
      errorMsg = message;
    });

    var response = await getList(
        url: 'https://jsonplaceholder.typicode.com/posts-bad-url',
        fromJson: (x) => Post.fromJson(x));

    expect(response.statusCode, 404);
    expect(response.isSuccess, false);
    expect(response.data == null, true);
    expect(errorMsg.isNotEmpty, true);
  });

  test('post', () async {
    var newPost = Post(title: 'title', body: 'body');
    var response = await post(
        url: 'https://jsonplaceholder.typicode.com/posts',
        body: newPost.toJson());

    expect(response.statusCode, 201);
    expect(response.isSuccess, true);
  });
}

class Post {
  Post({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}
