require "spec_helper"

class DummyHTTPClient
  attr_reader :post_url, :post_data, :post_options, :put_url, :put_data, :put_options

  def post(url, data, options)
    @post_url = url
    @post_data = data
    @post_options = options
  end

  def put(url, data, options)
    @put_url = url
    @put_data = data
    @put_options = options
  end
end

describe StatusClient do
  it "has a version number" do
    expect(StatusClient::VERSION).not_to be nil
  end

  describe "#create_status" do
    let(:http_client) { DummyHTTPClient.new }
    let(:url) { "http://example.com/status.json" }
    subject { StatusClient::Client.new http_client, url }

    before { subject.create_status('status text', 'message text') }
    it 'submits an http post to the correct url' do
      expect(http_client.post_url).to eq("http://example.com/status.json")
    end

    it 'includes the state text' do
      expect(http_client.post_data[:state]).to eq('status text')
    end

    it 'includes the message text' do
      expect(http_client.post_data[:message]).to eq('message text')
    end

    context 'includes the options' do
      it 'includes the json content-type' do
        expect(http_client.post_options[:content_type]).to eq(:json)
      end
      it 'includes the json accept' do
        expect(http_client.post_options[:accept]).to eq(:json)
      end
    end
  end

  describe "#update_status" do
    let(:http_client) { DummyHTTPClient.new }
    let(:url) { "http://example.com/status.json" }
    let(:id) { 16 }
    subject { StatusClient::Client.new http_client, url }

    before { subject.update_status(id, 'status text', 'message text') }

    it 'submits an http put to the correct url' do
      expect(http_client.put_url).to eq("http://example.com/status.json")
    end

    it 'includes the id' do
      expect(http_client.put_data[:id]).to eq(id)
    end

    it 'includes the state text' do
      expect(http_client.put_data[:state]).to eq('status text')
    end

    it 'includes the message text' do
      expect(http_client.put_data[:message]).to eq('message text')
    end

    context 'includes the options' do
      it 'includes the json content-type' do
        expect(http_client.put_options[:content_type]).to eq(:json)
      end
      it 'includes the json accept' do
        expect(http_client.put_options[:accept]).to eq(:json)
      end
    end
  end

end
