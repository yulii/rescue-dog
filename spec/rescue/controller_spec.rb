# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller do

  let(:object) do
    Class.new ApplicationController do
      extend Rescue::Controller::ClassMethods
    end
  end

  [:rescue_associate, :rescue_controller, :define_action_method].each do |name|
    describe "include ClassMethods module" do
      it "should be able to call method `#{name}`" do
        expect(object.public_methods.include? name).to be_true
      end
    end
  end

  #[:].each do |name|
  #  describe "include ClassMethods module" do
  #    it "should be able to call method `#{name}`" do
  #      expect(object.public_methods.include? name).to be_true
  #    end
  #  end
  #end

  describe "Rescue::Controller#rescue_controller" do
    let(:object) do
      Class.new ApplicationController do
        extend Rescue::Controller::ClassMethods
        rescue_controller RescueModel, :index, :show, :new, :edit, :create, :update, :delete
      end
    end

    it "should be defined private method `find_params`" do
      expect(object.private_instance_methods.include? :find_params).to be_true
    end

    [:find_call, :new_call, :create_call, :update_call, :delete_call].each do |name|
      it "should be defined private method `#{name}`" do
        expect(object.private_instance_methods.include? name).to be_true
      end
    end

    [:index, :show, :new, :edit, :create, :update, :delete].each do |name|
      it "should be defined public method `#{name}`" do
        expect(object.public_instance_methods.include? name).to be_true
      end
    end

    TestCase::Controller::RESCUE_OPTIONS.each do |options|
      context "when rescue_controller is called" do

        let(:object) do
          Class.new ApplicationController do
            extend Rescue::Controller::ClassMethods
            rescue_controller RescueModel, options
          end
        end

        options.each do |arg|
          if arg.is_a?(Symbol)
            it "should be defined private method `#{arg}_call`" do
              expect(object.private_instance_methods.include? :"#{arg}_call").to be_true
            end
          end
        end
      end
    end
  end

  #describe "permit" do
  #  let(:object) do
  #    clazz = Class.new ApplicationController do
  #      extend Rescue::Controller::ClassMethods
  #      rescue_controller RescueModel, :index, :show, :new, :edit, :create, :update, :delete
  #    end
  #    clazz.new
  #  end

  #  it do
  #    expect(object).to be_true
  #  end
  #end

end
