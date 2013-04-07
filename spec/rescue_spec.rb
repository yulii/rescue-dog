# coding: UTF-8
require 'spec_helper'

describe Rescue do

  describe "define_error_class :RescueStandardError" do
    let(:name) { :RescueStandardError }
    before     { Rescue::Bind.define_error_class name }

    it "expects to define an exception class" do
      expect(Object.const_defined? name).to be_true
    end

    it "expects to define an exception class that is a kind of StandardError" do
      expect(Object.const_get(name).new).to be_a_kind_of StandardError
    end
  end

  describe "define_error_class :RescueScriptError, ScriptError" do
    let(:name) { :RescueScriptError }
    before     { Rescue::Bind.define_error_class name, ScriptError }

    it "expects to define an exception class" do
      expect(Object.const_defined? name).to be_true
    end

    it "expects to define an exception class that is a kind of StandardError" do
      expect(Object.const_get(name).new).to be_a_kind_of ScriptError
    end
  end

end
