import 'package:flutter_test/flutter_test.dart';

import 'package:api_utils/api_utils.dart';

void main() {
  test('GetList Test', () async {
    var response = await getList(
      url: 'https://jsonplaceholder.typicode.com/posts',
      fromJson: (x) => Post.fromJson(x),
    );

    expect(response.statusCode, 200);
    expect(response.isSuccess, true);
    expect(response.data != null, true);
  });

  test('Api Logger Test', () async {
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
