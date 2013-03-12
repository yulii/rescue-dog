# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller do

  before do
    @r = UsersController.new
  end

  { ServerError: 500, NotFound: 404 }.each do |name, code|
    describe name do
      subject { Object.const_defined? name }
      it "should define '#{name}' class" do
        should be_true
      end

      subject { Object.const_get(name).new }
      it "should be a kind of StandardError" do
        should be_a_kind_of StandardError
      end
    end

    describe "respond_#{code} method" do
      subject { ApplicationController.method_defined? :"respond_#{code}" }
      it "should be defined in ApplicationController" do
        should be_true
      end

      subject { @r.methods.include?(:"respond_#{code}") }
      it "should be called in a subclass of ApplicationController" do
        should be_true
      end
    end

  end ## end each
end
