require 'hpricot'
require 'yacht_transfer/parser'
module YachtTransfer
  class Service
    def initialize(api_base, api_path, api_key)
      @api_base = api_base
      @api_path = api_path
      @api_key = api_key
    end
    
    def post(params)
#      Parser.parse(params[:method], Net::HTTP.post_form(url, params))
    end
    
    def post_file(params)
 #     Parser.parse(params[:method], Net::HTTP.post_multipart_form(url, params))
    end
    
    private
    def url
#      URI.parse('http://'+ @api_base + @api_path)
    end
  end
end
#    def logon(account)
#    def listings(account)
