# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller do

  let(:object) do
    clazz = Class.new ApplicationController do
      include Rescue::Controller::ClassMethods
    end
    clazz.new
  end

  describe "include ClassMethods module" do
    it "expects to be call `rescue_associate` method" do
      expect(object.methods.include? :rescue_associate).to be_true
    end
  end

end
