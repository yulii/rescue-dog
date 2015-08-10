# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller::Action do

  let(:model) do # Stub of Model Class
    clazz = Class.new
    clazz.stub(:new).with(any_args()) do
      object = Object.new
      object.stub(:attributes=).and_return(true)
      object.stub(:save!).and_return(true)
      object.stub(:destroy).and_return(true)
      object
    end
    clazz.stub(:where).and_return(clazz)
    clazz.stub(:find).and_return(clazz.new)
    clazz
  end

  describe "#define_call" do
    let(:controller) do # Fake Controller
      clazz = model
      Class.new do
        Rescue::Controller::Action.define_call self, clazz, :@rescue
      end
    end

    let(:object) do
      object = controller.new
      object.stub(:params).and_return({})
      object
    end

    let(:params) { {} }

    [:find_call, :new_call, :create_call, :update_call, :destroy_call].each do |name|
      it "should declare `#{name}` method as private" do
        expect(controller.private_instance_methods.include? name).to eq(true)
      end
      it "should not raise error" do
        expect { object.send(name, params) }.not_to raise_error
      end
    end
  end

  describe "#define" do
    let(:controller) do # Fake Controller
      clazz = model
      Class.new do
        Rescue::Controller::Action.define_call self, clazz, :@rescue
        Rescue::Controller::Action.define self,
          [:show, :edit, :new, :create, :update, :destroy],
          show: { render: lambda { 'show' } },
          edit: { render: lambda { 'edit' } },
          new:  { render: lambda { 'new' } },
          create:  { render: lambda { 'create' } },
          update:  { render: lambda { 'update' } },
          destroy: { render: lambda { 'destroy' } }
      end
    end

    let(:object) do
      object = controller.new
      object.stub(:params).and_return({})
      object.stub(:create_params).and_return({})
      object.stub(:update_params).and_return({})
      object.stub(:destroy_params).and_return({})

      # Stub: rescue_respond
      object.stub(:rescue_respond) do |call, params, options|
        options[:render].call
      end
      object
    end

    [:show, :edit, :new, :create, :update, :destroy].each do |name|
      it "should declare `#{name}` method" do
        expect(controller.public_instance_methods.include? name).to eq(true)
      end
      it "should render" do
        expect(object.send(name)).to eq(name.to_s)
      end
    end

    context "when unknown types are specified" do
      it do
        expect {
          Class.new do
            Rescue::Controller::Action.define self, [:action],
              action: { type: :undefined ,render: lambda { 'render' } ,rescue: lambda { 'rescue' } }
          end
        }.to raise_error(Rescue::NoActionError, Rescue::NoActionError.new(:undefined).message)
      end
    end

    context "when an action name is duplicated" do
      it "should not raise error for the first time" do
        expect {
          Class.new do
            Rescue::Controller::Action.define self, [:action],
              action: { type: :show ,render: lambda { 'render' } ,rescue: lambda { 'rescue' } }
          end
        }.not_to raise_error
      end
      it "should raise RuntimeError with \"`action` is already defined.\"" do
        expect {
          Class.new do
            def action ; end
            Rescue::Controller::Action.define self, [:action],
              action: { type: :show ,render: lambda { 'render' } ,rescue: lambda { 'rescue' } }
          end
        }.to raise_error(RuntimeError, "`action` is already defined.")
      end
    end

    context "when an parameter method is undefined" do
      { create:  :create_params,
        update:  :update_params,
        destroy: :destroy_params }.each do |name, params|
        it do
          expect {
            controller.new.send(name)
          }.to raise_error(Rescue::NoParameterMethodError, Rescue::NoParameterMethodError.new(controller, params).message)
        end
      end
    end
  end
end

