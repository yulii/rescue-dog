# Rescue Dog

The Rescue-Dog responds HTTP status (the code and message) when raise the exception.

## Installation

Add this line to your application's Gemfile:

    gem 'rescue-dog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rescue-dog

## Usage

1. Include `Rescue::Controller::Static` or `Rescue::Controller::Dynamic`.
2. Call `rescue_associate` method. And then, the exception class is defined and added to `rescue_handlers`.
3. Raise the exception or Call `response_status` method.

### Render Static Files
Render /public/400(.:format) if you raise BadRequest exception.

    $ vim app/controllers/application_controller.rb
    class ApplicationController
   
      include Rescue::Controller::Static
      rescue_associate :BadRequest   ,with: 400
      rescue_associate :Unauthorized ,with: 401
      rescue_associate :NotFound     ,with: 404
      rescue_associate :ServerError  ,with: 500

### Render Template
Render app/views/errors/404(.:format) if you raise NotFound exception.

    $ vim app/controllers/application_controller.rb
    class ApplicationController
   
      include Rescue::Controller::Dynamic
      rescue_associate :BadRequest   ,with: 400
      rescue_associate :Unauthorized ,with: 401
      rescue_associate :NotFound     ,with: 404
      rescue_associate :ServerError  ,with: 500

### Associated with the exceptions 
Call the response method when raise an exception.

#### for ActiveRecord
    rescue_associate ActiveRecord::RecordNotFound ,with: 404
#### for Mongoid
    rescue_associate Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId, with: 404


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## LICENSE
(The MIT License)

Copyright © 2013 yulii

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

