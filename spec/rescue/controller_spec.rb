# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller do

  let(:controller) do
    Class.new ApplicationController do
      include Rescue::Controller
      rescue_controller RescueModel,
        show: [:show_action],
        edit: [:edit_action],
        new:  [:new_action],
        create:  { render: lambda { } ,rescue: lambda { raise $! } },
        update:  { render: lambda { } ,rescue: lambda { raise $! } },
        destroy: { render: lambda { } ,rescue: lambda { raise $! } },
        create_action:  { type: :create  ,render: lambda { } ,rescue: lambda { raise $! } ,params: :customized_params },
        update_action:  { type: :update  ,render: lambda { } ,rescue: lambda { raise $! } ,params: :customized_params },
        destroy_action: { type: :destroy ,render: lambda { } ,rescue: lambda { raise $! } ,params: :customized_params }

      def customized_create_action
        rescue_respond(:create_call, create_params,
          render: lambda { },
          rescue: lambda { }
        )
      end

      def customized_update_action
        rescue_respond(:update_call, update_params,
          render: lambda { },
          rescue: lambda { }
        )
      end

      def customized_destroy_action
        rescue_respond(:destroy_call, destroy_params,
          render: lambda { },
          rescue: lambda { }
        )
      end

      def execute
        rescue_respond(:execute_call, execute_params,
          render: lambda { },
          rescue: lambda { }
        )
      end
    end
  end

  # Stub: flash object
  let(:flash) do
    flash = Hash.new
    flash.stub(:now).and_return({})
    flash
  end

  [:rescue_associate, :rescue_controller].each do |name|
    it "should declare `#{name}` method" do
      expect(controller.public_methods.include? name).to be_true
    end
  end

  [ :rescue_respond,
    :find_call, :new_call, :create_call, :update_call, :destroy_call].each do |name|
    it "should declare `#{name}` method as private" do
      expect(controller.private_instance_methods.include? name).to be_true
    end
  end

  [ :new, :edit, :show, :create, :update, :destroy,
    :show_action, :edit_action, :new_action,
    :create_action, :update_action, :destroy_action ].each do |name|
    it "should declare `#{name}` method as public" do
      expect(controller.public_instance_methods.include? name).to be_true
    end
  end

  context "when action is executed" do
    let(:object) do
      object = controller.new
      # Stub: flash message
      object.stub(:flash).and_return(flash)
      # Stub: controller/action name for flash messages
      object.stub(:controller_path).and_return('')
      object.stub(:controller_name).and_return('')
      object.stub(:action_name).and_return('')
  
      # Stub: parameter methods
      object.stub(:create_params).and_return({})
      object.stub(:update_params).and_return({})
      object.stub(:destroy_params).and_return({})
      object.stub(:execute_params).and_return({})
      object.stub(:customized_params).and_return({})
  
      # Stub: call methods
      object.stub(:find_call).with(any_args()).and_raise('find_call execute')
      object.stub(:new_call).and_raise('new_call execute')
      object.stub(:create_call).and_raise('create_call execute')
      object.stub(:update_call).and_raise('update_call execute')
      object.stub(:destroy_call).and_raise('destroy_call execute')
      object.stub(:execute_call).and_raise()
      object
    end

    # Action Type Relation
    { find:    [:show, :edit, :show_action, :edit_action],
      new:     [:new, :new_action],
      create:  [:create, :create_action],
      update:  [:update, :update_action],
      destroy: [:destroy, :destroy_action] 
      }.each do |type, names|
      names.each do |name|
        it "should run `#{type}_call` when `#{name}` is executed" do
          expect { object.send(name) }.to raise_error(RuntimeError, "#{type}_call execute")
        end
      end
    end

    #it "should be performed within 500 microseconds" do
    #  n = 10000
    #  measure = Benchmark.measure do
    #    n.times { object.execute }
    #  end
    #  expect(measure.total).to be < (500 * 1.0e-06 * n)
    #end
  end

  describe "#rescue_respond" do
    let(:object) do
      clazz = Class.new ApplicationController do
        include Rescue::Controller

        # Subjects
        def render_execute
          rescue_respond(:stub_call, {},
            render: lambda { 'render' },
            rescue: lambda { 'rescue' }
          )
        end

        def rescue_execute
          rescue_respond(:stub_call, {},
            render: lambda { raise RuntimeError },
            rescue: lambda { 'rescue' }
          )
        end
      end

      object = clazz.new
      object.stub(:flash).and_return(flash)
      object.stub(:controller_path).and_return('rescue')
      object.stub(:action_name).and_return('action')
      object.stub(:stub_call).with({},{}).and_return(nil)
      object
    end

    it "should render with no error" do
      expect(object.render_execute).to eq('render')
    end

    it "should render by the rescue block" do
      expect(object.rescue_execute).to eq('rescue')
    end
  end

end
