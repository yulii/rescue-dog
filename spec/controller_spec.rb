# coding: UTF-8
require 'spec_helper'

describe Responder::Controller do

  before do
    @r = UsersController.new
  end

  it { @r.methods.include?(:respond_404).should be_true }

end
