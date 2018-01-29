# Changelog

## 0.3.8
* Major version change as new class added to handle request.
* Classes separated in different files.
* Syntax for Hashes changed from hashrockets to symbol.
* Alias for request methods defined to match HTTP methods
* New class Database defined so that other Firebase services can be added in future and make Client deprecated.
* Rubocop fixes.

## 0.2.8

* Fix [auth token expiration](https://github.com/oscardelben/firebase-ruby/pull/84) on longer lived Firebase objects.

## 0.2.7

* Support newer Firebase [authentication method](https://github.com/oscardelben/firebase-ruby/pull/81)

## 0.2.5

* [Refactor to remove Request proxy class, expose http client](https://github.com/oscardelben/firebase-ruby/commit/138b1e1461ff33da506b0d7992b42e3544be9cf1)

## 0.2.4

* Add support for server timestamp.

## 0.2.3

* Switch from problematic `typhoeus` client to `HTTPClient`
* File permissions issue fix
* Follow redirect headers by default

## 0.2.2

* Update dependencies

## 0.2.1

* Fix auth parse exception

## 0.2.0

* You can now pass query options to get/push/set, etc.
* The old syntax no longer works. You now need to create instance variables of Firebase::Client.new(...)

## 0.1.6

* You can now create instances of Firebase. The old syntax still works but will be removed in version 0,2. - @wannabefro
