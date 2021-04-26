## [4.0.0]
* Breaking change: `headers` parameter changed from `Map<String, String>` to 
`Future<Map<String, String>> Function()` as users commonly need to asynchronously set headers like 
Authorization. Exceptions thrown during this function are caught and an appropriate ApiResponse is 
returned.

## [3.1.0]

* Added the ability to set the underlying http client

## [3.0.0]

* Null safety migration

## [2.0.0]

* Breaking change: ApiLogger renamed to ApiUtilsConfig
* Added the ability to set a global timeout for all requests on ApiUtilsConfig
* Added the ability to set a timeout per request. This will override the global setting if set.

## [1.0.0]

* Documentation updates, stable release

## [0.0.1]

* Initial release with REST utils and ApiLogger
