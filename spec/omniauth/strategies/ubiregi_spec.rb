require 'spec_helper'

describe OmniAuth::Strategies::Ubiregi do
  subject do
    described_class.new({})
  end

  context "client options" do
    it 'returns correct site' do
      expect(subject.options.client_options.site).to eq("https://ubiregi.com")
    end

    it 'returns correct authorize_url' do
      expect(subject.options.client_options.authorize_url).to eq("https://ubiregi.com/oauth2/authorize")
    end

    it 'returns correct token_url' do
      expect(subject.options.client_options.token_url).to eq("https://ubiregi.com/oauth2/token")
    end
  end

  context "uid" do
    before do
      allow(subject).to receive(:raw_info) { {"id" => "ubiregi" } }
    end

    it 'returns correct uid' do
      expect(subject.uid).to eq("ubiregi")
    end
  end

  context "info" do
    before do
      allow(subject).to receive(:raw_info) { { "email" => "valid@email.com", "name" => "ubiregi" } }
    end

    it 'returns correct info' do
      expect(subject.info).to eq({ email: "valid@email.com", name: "ubiregi" })
    end
  end

  context "extra" do
    before do
      allow(subject).to receive(:raw_info) { { "id" => "ubiregi" } }
    end

    it 'returns correct extra block' do
      expect(subject.extra).to eq( { raw_info: {"id" => "ubiregi" } })
    end
  end

  context "#raw_info" do
    let(:response_account_array) { { "email" => "valid@email.com", "name" => "ubiregi" } }
    let(:access_token) { double('AccessToken', options: {}) }
    let(:response) { double('Response', parsed: { "account" => response_account_array } ) }

    before do
      allow(subject).to receive(:access_token) { access_token }
    end

    it "returns raw_info" do
      allow(access_token).to receive(:get).with('/api/3/accounts/current') { response }
      expect(subject.raw_info).to eq(response_account_array)
    end
  end
end
