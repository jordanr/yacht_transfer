require 'net/http'
require "net/https"
require "multipart"
module YachtTransfer
  module Transferers
    # An abstract transferer implements the functions:
    #   * authentic? - test a connection to remote host w/ the given 
    #		      username + password
    #   * create - remotely create a local listing
    #   * read   - pull in a remote listing to this local client
    #   * update - update an already created remote listing
    #   * delete - permanantly delete a created remote listing
    module AbstractTransferer
      class LoginFailedError < StandardError;  end
      class BadIdError < StandardError;  end
      class NotReadyError < StandardError;  end
      class NotImplementedError < StandardError;  end

      attr_accessor :username, :password

      def initialize(username, password)
        @username = username
        @password = password
      end

      ############
      # Absracts
      ##########

      def authentic?
        raise NotImplementedError, "subclass should have overriden"
      end
      def create(listing)
        raise NotImplementedError, "subclass should have overriden"
      end
      def read(id)
        raise NotImplementedError, "subclass should have overriden"
      end
      def update(listing, id)
        raise NotImplementedError, "subclass should have overriden"
      end
      def delete(id)
        raise NotImplementedError, "subclass should have overriden"
      end

      ##########
      # HTTP requests
      ##########

      def get(url)
        url = URI.parse(url)
        http= agent(url.host, url.port)
        req = request("#{url.path.to_s}?#{url.query.to_s}", :get)
        res = http.request(req)
	raise RequestError unless res.is_a?(Net::HTTPSuccess)
        res.body
      end

      def post(url, params)
        url = URI.parse(url)
        http = agent(url.host, url.port)
        req = request("#{url.path.to_s}?#{url.query.to_s}", :post)
#        req = request(url.path, :post)
        req.set_form_data(params)

        res = http.request(req)
  	raise RequestError unless res.is_a?(Net::HTTPSuccess)
        res.body
      end

      def multipart_post(url, params, initheaders=nil)
	mp = Multipart::MultipartPost.new
        query, headers = mp.prepare_query(params)
        headers.merge!(initheaders) if initheaders
        url = URI.parse(url)
        http = agent(url.host, url.port)
        req = request("#{url.path.to_s}?#{url.query.to_s}", :post, headers)
#        req = request(url.path, :post, headers)
        req.set_form_data(query)
	res = http.request(req)

        return res['location'] if res.is_a?(Net::HTTPRedirection)

       	raise RequestError unless res.is_a?(Net::HTTPSuccess)
        return res.body
      end       

     ##########
     # Hooks 

      def agent(host, port)
        http = Net::HTTP.new(host, port)
#        http.set_debug_output $stderr
        http
      end

      def request(path, method, initheader=nil)
        if method == :get
          req = Net::HTTP::Get.new(path, initheader)
        elsif method == :post
          req = Net::HTTP::Post.new(path, initheader)
	else
	  raise ArgumentError("unknown method")
        end
      end

      def fetch(uri_str, limit = 10)
        # You should choose better exception.
        raise ArgumentError, 'HTTP redirect too deep' if limit == 0

        response = Net::HTTP.get_response(URI.parse(uri_str))
        case response
        when Net::HTTPSuccess     then response
        when Net::HTTPRedirection then fetch(response['location'], limit - 1)
        else
          response.error!
      end
    end


    end
  end
end

class RequestError < StandardError; end
