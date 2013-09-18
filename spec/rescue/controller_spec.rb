# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller do

  let(:object) do
    Class.new ApplicationController do
      include Rescue::Controller
      rescue_controller RescueModel,
        show: [:show_action],
        edit: [:edit_action],
        new:  [:new_action],
        create:  { render: lambda { } ,rescue: lambda { } },
        update:  { render: lambda { } ,rescue: lambda { } },
        destroy: { render: lambda { } ,rescue: lambda { } },
        create_action:  { type: :create  ,render: lambda { } ,rescue: lambda { } },
        update_action:  { type: :update  ,render: lambda { } ,rescue: lambda { } },
        destroy_action: { type: :destroy ,render: lambda { } ,rescue: lambda { } }

      def customized_create_action
        rescue_respond(:create_call, create_params,
          render: lambda { },
          rescue: lambda { }
        )
      end

      def customized_update_action
        rescue_respond(:update_call, update_params,
          render: lambda { return true },
          rescue: lambda { }
        )
      end

      def customized_destroy_action
        rescue_respond(:destroy_call, destroy_params,
          render: lambda { },
          rescue: lambda { }
        )
      end
    end
  end

  it "should be defined `rescue_respond`" do
    expect(object.method_defined? :rescue_respond).to be_true
  end

  [:rescue_associate, :rescue_controller].each do |name|
    it "should be able to call method `#{name}`" do
      expect(object.public_methods.include? name).to be_true
    end
  end


  describe "#rescue_respond" do
    let(:object) do
      clazz = Class.new ApplicationController do
        include Rescue::Controller
      end
      object = clazz.new
      object.stub(:flash).and_return({})
      object.stub(:controller_path).and_return('rescue')
      object.stub(:action_name).and_return('action')
      object.stub(:stub_call).with({}).and_return(nil)
      object
    end

    it "should be able to render" do
      expect(
        object.send(:rescue_respond, :stub_call, {},
          render: lambda { return 'render' },
          rescue: lambda { return 'rescue' })
      ).to eq('render')
    end

  end

  describe Rescue::Controller::ClassMethods do
    describe "#rescue_controller" do

      let(:object) do
        Class.new ApplicationController do
          extend Rescue::Controller::ClassMethods
          rescue_controller RescueModel,
            show: [:show_action],
            edit: [:edit_action],
            new:  [:new_action],
            create:  { render: lambda { } ,rescue: lambda { } },
            update:  { render: lambda { } ,rescue: lambda { } },
            destroy: { render: lambda { } ,rescue: lambda { } },
            create_action:  { type: :create  ,render: lambda { } ,rescue: lambda { } },
            update_action:  { type: :update  ,render: lambda { } ,rescue: lambda { } },
            destroy_action: { type: :destroy ,render: lambda { } ,rescue: lambda { } }
        end
      end

      [:find_call, :new_call, :create_call, :update_call, :destroy_call].each do |name|
        it "should be defined private method `#{name}`" do
          expect(object.private_instance_methods.include? name).to be_true
        end
      end
  
      [ :new, :edit, :show, :create, :update, :destroy,
        :show_action, :edit_action, :new_action,
        :create_action, :update_action, :destroy_action ].each do |name|
        it "should be defined public method `#{name}`" do
          expect(object.public_instance_methods.include? name).to be_true
        end
      end

    end
  end

end
