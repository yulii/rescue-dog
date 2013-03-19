# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller::Static do

  let(:object) { StaticController.new }

  describe "respond method" do
    subject { object.methods.include?(:respond_status) }
    it "should be called in a subclass of ApplicationController" do
      should be_true
    end
  end

  TestCase::Controller::ERRORS.each do |name, code|

    describe "response when raise #{name}" do
      TestCase::Controller::FORMATS.each do |format|
        context "request format => #{format}" do
          before do
            visit "/static/#{name.to_s.underscore}.#{format.to_sym}"
          end

          subject { page }
          it { should have_content name.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1 \2').gsub(/([a-z\d])([A-Z])/,'\1 \2') }
          it { response_headers["Content-Type"].should include(format.to_s) }
        end
      end
    end
  end ## end each

end
