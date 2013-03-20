# coding: UTF-8
require 'spec_helper'

describe Rescue do

  describe "define_error_class :RescueStandardError" do
    let(:name) { :RescueStandardError }
    before     { Rescue::Bind.define_error_class name }

    subject { Object.const_defined? name }
    it "should define an exception class" do
      should be_true
    end

    subject { Object.const_get(name).new }
    it "should define an exception class that is a kind of StandardError" do
      should be_a_kind_of StandardError
    end
  end

  describe "define_error_class :RescueScriptError, ScriptError" do
    let(:name) { :RescueScriptError }
    before     { Rescue::Bind.define_error_class name, ScriptError }

    subject { Object.const_defined? name }
    it "should define an exception class" do
      should be_true
    end

    subject { Object.const_get(name).new }
    it "should define an exception class that is a kind of StandardError" do
      should be_a_kind_of ScriptError
    end
  end

end
