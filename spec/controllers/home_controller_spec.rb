require 'spec_helper'

describe HomeController do
  describe '#index' do
    let(:popular) { stub('popular') }
    let(:rated)   { stub('rated') }
    
    before :each do
      FakeWeb.register_uri :get, /http:\/\/127\.0\.0\.1:5984\/laughtrack/,
        :body => '{"total_rows": 0, "rows": [], "offset": 0}'
    end    
  end
end
