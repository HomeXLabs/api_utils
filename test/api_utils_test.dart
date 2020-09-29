import 'package:flutter_test/flutter_test.dart';

import 'package:api_utils/api_utils.dart';

void main() {
  test('getList', () async {
    var response = await getList(
      url: 'https://jsonplaceholder.typicode.com/posts',
      fromJson: (x) => Post.fromJson(x),
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
