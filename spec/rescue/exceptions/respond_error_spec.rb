# coding: UTF-8
require 'spec_helper'

describe Rescue::RespondError do

  Rescue::ApplicationError::STATUS_CODES.each do |code, e|
    describe "#{code} #{e[:status]}" do
      let(:name) { e[:status].gsub(' ', '') }

      it "expects to define an exception class of #{e[:status]}" do
        expect(Object.const_defined? name).to be_true
      end

      it "expects to define an exception class that is a kind of Rescue::ApplicationError" do
        expect(Object.const_get(name).new).to be_a_kind_of Rescue::ApplicationError
      end
    end
  end

  describe "HTTP Status Code" do
    context "Suppress Response code is #{Rescue.config.suppress_response_codes}" do
      Rescue::ApplicationError::STATUS_CODES.each do |code, e|
        describe "#{code} #{e[:status]}" do
          before do
            visit "/status//#{code}.json"
          end

          it "expects to return #{Rescue.config.suppress_response_codes ? 200 : e[:http]}" do
            expect(page.status_code).to eq (Rescue.config.suppress_response_codes ? 200 : e[:http])
          end
        end
      end
    end
  end

end
