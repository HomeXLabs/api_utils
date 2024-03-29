# Api Utils for Dart & Flutter
[![pub package](https://img.shields.io/pub/v/api_utils.svg?label=api_utils&color=blue)](https://pub.dev/packages/api_utils)

*ain't no REST for the wicked*
## Intro
A collection of helper functions and an `ApiResponse` class that make working with REST apis a bit easier.
## Usage
Here is an example of making a `GET` to an endpoint that returns a list. 

All you need is a model with a `fromJson` contructor. This ensures you app only interacts with strongly typed models, not raw JSON lists and maps. [Json_serializable](https://pub.dev/packages/json_serializable) is a commonly used dart package that provides this functionality.
```dart
var response = await getList(
    url: 'https://jsonplaceholder.typicode.com/posts',
    fromJson: (x) => Post.fromJson(x),
);
```
Similarly for POST
```dart
var newPost = Post(title: 'title', body: 'body');
var response = await post(
    url: 'https://jsonplaceholder.typicode.com/posts',
    body: newPost.toJson(),
);
```
## Error Logging
It can be helpful to have a single place to log errors to the console or to a logging service.

`message` will always be populated. `exception` and `stack` will be populated if an exception is thrown when making the request.
```dart
ApiLogger.onErrorMiddleware.add((message, exception, stack) {
    if (kReleaseMode) {
        // log to logging service
    } else {
        // log to console
    }
});
```

## Publish / Release New Version
* Update the `CHANGELOG.md` to add a description of the change.
* Update the version number in `pubspec.yaml`.
* Create a new Release in:
https://github.com/HomeXLabs/api_utils/releases

