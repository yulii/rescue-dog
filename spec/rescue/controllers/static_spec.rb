# coding: UTF-8
require 'spec_helper'

describe Rescue::Controller::Static do

  let(:object) { StaticController.new }

  describe "respond method" do
    it "expects to be called in a subclass of ApplicationController" do
      expect(object.methods.include? Rescue.config.respond_name).to eq(true)
    end
  end

  TestCase::Controller::ERRORS.each do |name, code|

    describe "response when raise #{name}" do
      TestCase::Controller::FORMATS.each do |format|
        context "request format => #{format}" do
          before do
            visit "/static/#{name.to_s.underscore}.#{format.to_sym}"
          end

          it { expect(page).to have_content name.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1 \2').gsub(/([a-z\d])([A-Z])/,'\1 \2') }
          it { expect(response_headers["Content-Type"]).to include(format.to_s) }
        end
      end
    end
  end ## end each

end
