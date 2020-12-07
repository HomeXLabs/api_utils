// @dart=2.9
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
        return null;
      }
    }));
  });

  test('getList', () async {
    var response = await getList(
      url: 'https://jsonplaceholder.typicode.com/posts',
      fromJson: (x) => Post.fromJson(x),
      headers: {}
    );

    expect(response.statusCode, 200);
    expect(response.isSuccess, true);
    expect(response.data != null, true);
  });

  test('ApiLogger logs', () async {
    String errorMsg;
    ApiLogger.onErrorMiddleware.add((message, e, stack) {
      errorMsg = message;
    });

    var response = await getList(
      url: 'https://jsonplaceholder.typicode.com/posts-bad-url',
      fromJson: (x) => Post.fromJson(x),
      headers: {}
    );

    expect(response.statusCode, 404);
    expect(response.isSuccess, false);
    expect(response.data == null, true);
    expect(errorMsg != null, true);
  });

  test('post', () async {
    var newPost = Post(title: 'title', body: 'body');
    var response = await post(
      url: 'https://jsonplaceholder.typicode.com/posts',
      body: newPost.toJson(),
      headers: {}
    );

    expect(response.statusCode, 201);
    expect(response.isSuccess, true);
  });
}

class Post {
  Post({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  final int userId;
  final int id;
  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
