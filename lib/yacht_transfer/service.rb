require 'net/http'
require 'yacht_transfer/parser'
module YachtTransfer
  class Service
    def initialize(host, username)
      @host = host
      @username = username
    end

    # TODO: support ssl
    def post(params)
      Parser.parse(params[:method], Net::HTTP.post_form(url, params))
    end

    def post_file(params)
      Parser.parse(params[:method], Net::HTTP.post_multipart_form(url, params))
    end

    private
    def url
      URI.parse('http://'+ @host)
    end
  end
end
