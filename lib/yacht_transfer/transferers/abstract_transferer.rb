require "rubygems"
require "mechanize"
require 'yacht_transfer/standards'
module YachtTransfer
  module Transferers
    # An abstract transferer implements the functions:
    #   * login - test a connection to remote host w/ the given 
    #		  username + password
    #   * create - remotely create a local listing
    #   * read   - pull in a remote listing to this local client
    #   * update - update an already created remote listing
    #   * delete - permanantly delete a created remote listing
    module AbstractTransferer
	include YachtTransfer::Standards
      class LoginFailedError < StandardError;  end
      class BadIdError < StandardError;  end
      class NotReadyError < StandardError;  end
      class NotImplementedError < StandardError;  end

      attr_accessor :username, :password

      def initialize(username, password)
        @username = username
        @password = password
      end

      def logged_on?
	@logged_on
      end

      def login
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

      def agent
        @agent ||= WWW::Mechanize.new
      end
    end
  end
end
