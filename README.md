# firebase

Ruby wrapper for the Firebase backend API.

Changes are sent to all subscribed clients automatically, so you can
update your clients **in realtime from the backend**.

See a [video demo](https://vimeo.com/41494336?utm_source=internal&utm_medium=email&utm_content=cliptranscoded&utm_campaign=adminclip) of what's possible.

### Installation


```
gem install firebase
```

### Usage


```ruby
Firebase.base_uri = 'http://gamma.firebase.com/youruser'

response = Firebase.push("todos", { :name => 'Pick the milk', :priority => 1 })
response.success? # => true
response.code # => 200
response.body # => { 'name' => "-INOQPH-aV_psbk3ZXEX" }
response.raw_body # => '{"name":"-INOQPH-aV_psbk3ZXEX"}'
```

If you have a read-only namespace, set your secret key as follows:
```ruby
Firebase.base_uri = 'http://gamma.firebase.com/youruser'
Firebase.auth = 'yoursecretkey'

response = Firebase.push("todos", { :name => 'Pick the milk', :priority => 1 })
```


So far, supported methods are:

```ruby
Firebase.set(path, data)
Firebase.get(path)
Firebase.push(path, data)
Firebase.delete(path)
```

More features are coming soon.

More information about Firebase and the Firebase API is available at the
[official website](http://www.firebase.com/).

### Copyright

Copyright (c) 2012 Oscar Del Ben. See LICENSE.txt for
further details.

