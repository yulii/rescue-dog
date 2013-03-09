# Rescue Dog

respond to an exception raised in Rails

## Installation

Add this line to your application's Gemfile:

    gem 'rescue-dog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rescue-dog

## Usage

    $ vim app/controllers/application_controller.rb
    class ApplicationController
   
      include Rescue::Controller
      define_errors ServerError: 500, NotFound: 404
   
      # Call the response method when raise an exception
      #   for ActiveRecord
      rescue_from ActiveRecord::RecordNotFound, with: respond_404
      #   for Mongoid
      rescue_from Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId, with: :respond_404

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
