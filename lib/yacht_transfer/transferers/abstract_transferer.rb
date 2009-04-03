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
    #   * destroy - permanantly delete a created remote listing
    module AbstractTransferer
      class LoginFailedError < StandardError;  end
      class BadIdError < StandardError;  end
      class NotReadyError < StandardError;  end
      class NotImplementedError < StandardError;  end

      attr_accessor :username, :password

      def initialize(username, password)
        @username = username
        @password = password
	@agent = nil
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
      def destroy(id)
        raise NotImplementedError, "subclass should have overriden"
      end

      ##########
      # HTTP requests
      ##########

      def get(url, initheaders = nil)
        url = URI.parse(url)
        http= agent(url.host, url.port)
	if url.query
          req = request("#{url.path.to_s}?#{url.query.to_s}", :get, initheaders)
	else
          req = request("#{url.path.to_s}", :get, initheaders)
	end
        res = http.request(req)
#	raise RequestError unless res.is_a?(Net::HTTPSuccess)
        res
      end

      def post(url, params, initheaders = nil)
        url = URI.parse(url)
        http = agent(url.host, url.port)
	if url.query
          req = request("#{url.path.to_s}?#{url.query.to_s}", :post, initheaders)
	else
          req = request("#{url.path.to_s}", :post, initheaders)
	end
#        req = request(url.path, :post)
        req.set_form_data(params)

        res = http.request(req)
#  	raise RequestError unless res.is_a?(Net::HTTPSuccess)
        res
      end

      def multipart_post(url, params, initheaders=nil)
	mp = Multipart::MultipartPost.new
        query, headers = mp.prepare_query(params)
        headers.merge!(initheaders) if initheaders
        url = URI.parse(url)
        http = agent(url.host, url.port)
	if url.query
          req = request("#{url.path.to_s}?#{url.query.to_s}", :post, headers)
	else
          req = request("#{url.path.to_s}", :post, headers)
	end

#        req = request(url.path, :post, headers)
#        req.set_form_data(query)
	res = http.request(req, query)

#       	raise RequestError unless res.is_a?(Net::HTTPSuccess ||)
        return res
      end       

     ##########
     # Hooks 

      def agent(host, port)
	return @agent if @agent
        http = Net::HTTP.new(host, port)
#        http.set_debug_output $stdout
        http
      end

      def request(path, method, headers=nil)
        if method == :get
          req = Net::HTTP::Get.new(path)
        elsif method == :post
          req = Net::HTTP::Post.new(path)
	else
	  raise ArgumentError("unknown method")
        end	
#	headers.each_pair { |k, v| req.add_field(k, v) } if headers
      end


    end
  end
end

class RequestError < StandardError; end
