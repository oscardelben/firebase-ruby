# Changelog

## 0.2.5

* Add support for setting request timeout values. 

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
