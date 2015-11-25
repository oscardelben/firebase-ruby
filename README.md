# firebase [![Build Status](https://travis-ci.org/oscardelben/firebase-ruby.svg?branch=master)](https://travis-ci.org/oscardelben/firebase-ruby)

Ruby wrapper for the [Firebase REST API](https://www.firebase.com/docs/rest/api/).

Changes are sent to all subscribed clients automatically, so you can
update your clients **in realtime from the backend**.

See a [video demo](https://vimeo.com/41494336?utm_source=internal&utm_medium=email&utm_content=cliptranscoded&utm_campaign=adminclip) of what's possible.

## Installation

```
gem install firebase
```
## Usage

```ruby
base_uri = 'https://<your-firebase>.firebaseio.com/'

firebase = Firebase::Client.new(base_uri)

response = firebase.push("todos", { :name => 'Pick the milk', :priority => 1 })
response.success? # => true
response.code # => 200
response.body # => { 'name' => "-INOQPH-aV_psbk3ZXEX" }
response.raw_body # => '{"name":"-INOQPH-aV_psbk3ZXEX"}'
```

If you have a read-only namespace, set your secret key as follows:
```ruby
firebase = Firebase::Client.new(base_uri, secret_key)

response = firebase.push("todos", { :name => 'Pick the milk', :priority => 1 })
```

You can now pass custom query options to firebase:

```ruby
response = firebase.push("todos", :limit => 1)
```

To populate a value with a Firebase server timestamp, you can set `Firebase::ServerValue::TIMESTAMP` as a normal value. This is analogous to passing `Firebase.ServerValue.TIMESTAMP` in the [official JavaScript client](https://www.firebase.com/docs/web/api/servervalue/timestamp.html).

```ruby
response = firebase.push("todos", {
  :name => 'Pick the milk',
  :created => Firebase::ServerValue::TIMESTAMP
})
```

So far, supported methods are:

```ruby
set(path, data, query_options)
get(path, query_options)
push(path, data, query_options)
delete(path, query_options)
update(path, data, query_options)
```

### Configuring HTTP options

[httpclient](https://github.com/nahi/httpclient) is used under the covers to make HTTP requests.
You may find yourself wanting to tweak the timeout settings. By default, `httpclient` uses
some [sane defaults](https://github.com/nahi/httpclient/blob/dd322d39d4d11c48f7bbbc05ed6273ac912d3e3b/lib/httpclient/session.rb#L138),
but it is quite easy to change them by modifying the `request` object directly:

```ruby
firebase = Firebase::Client.new(base_uri)
# firebase.request is a regular httpclient object
firebase.request.connect_timeout = 30
```

More information about Firebase and the Firebase API is available at the
[official website](http://www.firebase.com/).

## Copyright

Copyright (c) 2013 Oscar Del Ben. See LICENSE.txt for
further details.
