# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller::Dynamic do

  let(:object) { DynamicController.new }

  describe "respond method" do
    it "expects to be called in a subclass of ApplicationController" do
      expect(object.methods.include? :respond_status).to be_true
    end
  end

  TestCase::Controller::ERRORS.each do |name, code|

    describe "response when raise #{name}" do
      TestCase::Controller::FORMATS.each do |format|
        context "request format => #{format}" do
          before do
            visit "/dynamic/#{name.to_s.underscore}.#{format.to_sym}"
          end

          it { expect(page).to have_content name.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1 \2').gsub(/([a-z\d])([A-Z])/,'\1 \2') }
          it { expect(page).to have_content "This is an explanation of what caused the error." } unless format.to_sym == :html
          it { expect(response_headers["Content-Type"]).to include(format.to_s) }
        end
      end
    end
  end ## end each

end
