require "rubygems"
require "mechanize"
require 'yacht_transfer/standards'
module YachtTransfer
  module Uploaders
    class BaseUploader
	include YachtTransfer::Standards
      class LoginFailedError < StandardError;  end
      class BadIdError < StandardError;  end
      class NotReadyError < StandardError;  end
      class NotImplementedError < StandardError;  end

      attr_accessor :username, :password, :listing, :id

      def initialize(username, password, listing, id=nil)
        @username = username
        @password = password
        @listing = listing
	@id = id
      end

      def logged_on?
	@logged_on
      end

      def agent
        @agent ||= WWW::Mechanize.new
      end

      def login
        raise NotImplementedError, "subclass should have overriden"
      end

# CRUD
      def create
        raise NotImplementedError, "subclass should have overriden"
      end
      def read
        raise NotImplementedError, "subclass should have overriden"
      end
      def update
        raise NotImplementedError, "subclass should have overriden"
      end
      def delete
        raise NotImplementedError, "subclass should have overriden"
      end

    end
  end
end
