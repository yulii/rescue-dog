# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller do

  let(:dynamic) do
    clazz = Class.new ApplicatoinController do
      include Rescue::Controller
      define_errors :dynamic, BadRequest: 400, Unauthorized: 401, NotFound: 404, ServerError: 500
    end
    clazz.new
  end

end
