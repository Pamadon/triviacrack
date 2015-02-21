require "spec_helper"

describe TriviaCrack::API::Login do

  let(:client) { (Class.new { include TriviaCrack::API::Login }).new }
  let(:login_data) { SpecData.get "login.json" }
  let(:error_code) { 400 }

  describe "#login" do
    it "should return correct user id and username when succesful" do
      response = double(code: 200, body: login_data)

      allow(Unirest).to receive(:post) { response }

      user_id, username = client.login "user@example.com", "password123"

      expect(user_id).to eq(111)
      expect(username).to eq("example")
    end

    it "should set the session id to the value returned by the request" do
      response = double(code: 200, body: login_data)

      allow(Unirest).to receive(:post) { response }

      expect(Unirest).to receive(:default_header)
                           .with("Cookie", "ap_session=session123")

      client.login "user@example.com", "password123"
    end

    it "should raise an exception when request fails" do
      response = double(code: error_code)

      allow(Unirest).to receive(:post) { response }

      expect { client.login "user@example.com", "password123" }.to raise_error
    end
  end

end
