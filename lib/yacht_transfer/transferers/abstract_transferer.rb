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

      def get(url)
        urll = URI.parse(url)
        http=Net::HTTP.new(urll.host, urll.port)
        req = Net::HTTP::Get.new(urll.path)
        res = http.request(req)
	raise RequestError unless res.is_a?(Net::HTTPSuccess)
        res.body
      end

      def post(url, params)
        res = Net::HTTP.post_form(URI.parse(url), params)
	raise RequestError unless res.is_a?(Net::HTTPSuccess)
        res.body
      end

      def multipart_post(url, params)
	mp = Multipart::MultipartPost.new
        query, headers = mp.prepare_query(params)
        urll = URI.parse(url)
	res = Net::HTTP.start(urll.host, urll.port) { |con|
	  con.post(urll.path, query, headers)
        }
	raise RequestError unless res.is_a?(Net::HTTPSuccess)
        res.body
      end       
    end
  end
end

class RequestError < StandardError; end
