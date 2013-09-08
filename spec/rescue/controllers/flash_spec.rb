# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller::Flash do

  before(:all) do
    TestCase::Controller::FLASHS.each do |name|
      Object.const_set name, Class.new {}
    end

    Rescue.const_set :DogController, Class.new {}
  end

  describe "Rescue::Controller::Flash#message" do
    TestCase::Controller::FLASHS.each do |name|
      [:success, :error].each do |status|
        it do
          expect(Rescue::Controller::Flash.message(Object.const_get(name).new, :action, status)).to eq("#{name.to_s.underscore} #{status}")
        end
      end
    end

    [:success, :error].each do |status|
      it do
        expect(Rescue::Controller::Flash.message(Rescue::DogController.new, :action, status)).to eq(status.to_s)
      end
    end
  end

end
