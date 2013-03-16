# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller::Static do

  let(:object) { StaticController.new }

  TestCase::Controller::ERRORS.each do |name, code|

    describe "respond_#{code} method" do
      subject { object.methods.include?(:"respond_#{code}") }
      it "should be called in a subclass of ApplicationController" do
        should be_true
      end
    end

    describe "raise #{name}" do
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
