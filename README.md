# Rescue Dog
[![Gem Version](https://badge.fury.io/rb/rescue-dog.png)](http://badge.fury.io/rb/rescue-dog)
[![Coverage Status](https://coveralls.io/repos/yulii/rescue-dog/badge.png?branch=master)](https://coveralls.io/r/yulii/rescue-dog)
[![Build Status](https://travis-ci.org/yulii/rescue-dog.png)](https://travis-ci.org/yulii/rescue-dog)

The Rescue-Dog responds HTTP status (the code and message) when raise the exception.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rescue-dog'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install rescue-dog
```

## Usage

1. Include `Rescue::Controller::Static` or `Rescue::Controller::Dynamic`.
2. Call `rescue_associate` method. And then, the exception class is defined and added to `rescue_handlers`.
3. Raise the exception or Call `response_status` method.

### Render Static Files
Render /public/400(.:format) if you raise BadRequest exception.

```bash
$ vim app/controllers/application_controller.rb
```

```ruby
class ApplicationController
   
  include Rescue::Controller::Static
  rescue_associate :BadRequest   ,with: 400
  rescue_associate :Unauthorized ,with: 401
  rescue_associate :NotFound     ,with: 404
  rescue_associate :ServerError  ,with: 500
```

### Render Template
Render app/views/errors/404(.:format) if you raise NotFound exception.

```bash
$ vim app/controllers/application_controller.rb
```

```ruby
class ApplicationController
   
  include Rescue::Controller::Dynamic
  rescue_associate :BadRequest   ,with: 400
  rescue_associate :Unauthorized ,with: 401
  rescue_associate :NotFound     ,with: 404
  rescue_associate :ServerError  ,with: 500
```

### Associated with the exceptions 
Call the response method when raise an exception.

#### for ActiveRecord

```ruby
rescue_associate ActiveRecord::RecordNotFound ,with: 404
```

#### for Mongoid

```ruby
rescue_associate Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId, with: 404
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## LICENSE
(The MIT License)

Copyright © 2013 yulii. See LICENSE.txt for further details.
