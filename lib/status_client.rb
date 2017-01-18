require "status_client/version"
require 'rest-client'

module StatusClient
  def client
    Client.new RestClient, 'http://litmus:secret@localhost:3000/status.json'
  end

  class Client
    def initialize(http_client, url)
      @http_client = http_client
      @url = url
    end

    def create_status(status, message)
      create_data = {state: status, message: message}
      @http_client.post @url, create_data, {content_type: :json, accept: :json}
    end

    def update_status(id, state=nil, message=nil)
      update_data = {id: id, state: state, message: message}
      @http_client.put @url, update_data, {content_type: :json, accept: :json}
    end
  end
end
