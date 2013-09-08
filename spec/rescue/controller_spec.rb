# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller do

  describe Rescue::Controller::ClassMethods do
    let(:object) do
      Class.new ApplicationController do
        extend Rescue::Controller::ClassMethods
      end
    end

    [:rescue_associate, :rescue_controller, :define_action_method].each do |name|
      it "should be able to call method `#{name}`" do
        expect(object.public_methods.include? name).to be_true
      end
    end
  end

  describe "Rescue::Controller#rescue_controller" do
    let(:object) do
      Class.new ApplicationController do
        extend Rescue::Controller::ClassMethods
        rescue_controller RescueModel, :show, :new, :edit, { create: {}, update: {}, delete: {} }
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

    [:new, :edit, :show, :create, :update, :delete].each do |name|
      it "should be defined public method `#{name}`" do
        expect(object.public_instance_methods.include? name).to be_true
      end
    end

    TestCase::Controller::RESCUE_OPTIONS.each do |args|
      context "when `rescue_controller` is called #{args}" do
        options = args.extract_options!
        methods = args + options.keys

        let(:object) do
          Class.new ApplicationController do
            extend Rescue::Controller::ClassMethods
            rescue_controller RescueModel, *args.dup, options.dup
          end
        end

        [:find_call, :new_call, :create_call, :update_call, :delete_call].each do |name|
          it "should be defined private method `#{name}`" do
            expect(object.private_instance_methods.include? name).to be_true
          end
        end

        [:index, :new, :edit, :show, :create, :update, :delete].each do |name|
          if methods.include? name
            it "should be defined public method `#{name}`" do
              expect(object.public_instance_methods.include? name).to be_true
            end
          else
            it "should not be defined method `#{name}`" do
              expect(object.instance_methods.include? name).to be_false
            end
          end
        end
      end
    end
  end

end
