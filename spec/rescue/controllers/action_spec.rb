# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller::Action do

  let(:model) do # Stub of Model Class
    clazz = Class.new
    clazz.stub(:new).with(any_args()) do
      object = Object.new
      object.stub(:attributes=).and_return(true)
      object.stub(:save!).and_return(true)
      object.stub(:destroy!).and_return(true)
      object
    end
    clazz.stub(:find).and_return(clazz.new)
    clazz
  end

  let(:controller) do # Fake Controller
    clazz = model
    Class.new do
      Rescue::Controller::Action.define self, clazz, :@rescue, :rescue_params
    end
  end

  let(:object) do
    object = controller.new
    object.stub(:find_params).and_return({})
    object.stub(:rescue_params).and_return({})
    object
  end

  let(:exception) do
    Class.new(RuntimeError)
  end

  describe "#define" do
    [:find_call, :new_call, :create_call, :update_call, :delete_call].each do |name|
      it "should be defined private method `#{name}`" do
        expect(controller.private_instance_methods.include? name).to be_true
      end
    end
  end

  [:find_call, :new_call].each do |name|
    describe "##{name}" do
      it { expect { object.send(name) }.not_to raise_error }
    end
  end

  [:create_call, :update_call, :delete_call].each do |name|
    describe "##{name}" do
      it { expect { object.send(name) }.not_to raise_error }

      context "with &block" do
        let(:block) { raise exception }

        it "should execute block-process" do
          expect { object.send(name, &block) }.to raise_error(exception)
        end
      end
      
    end
  end

end
