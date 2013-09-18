# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller::Flash do

  describe "#message" do
    ['default', 'rescue', 'rescue/dog'].each do |name|
      context "when #{{ controller: name, action: :action }}" do

        let(:controller) do
          clazz = Class.new
          clazz.stub(:controller_path).and_return(name)
          clazz.stub(:controller_name).and_return(name)
          clazz.stub(:action_name).and_return(:action)
          clazz
        end

        [:success, :error].each do |status|
          it do
            expect(Rescue::Controller::Flash.message(controller, status)).to eq("#{name} #{status}")
          end
        end
      end
    end
  end

end
