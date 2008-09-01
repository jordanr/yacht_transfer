require "rubygems"
require "mechanize"
require 'yacht_transfer/standards'
module Js2Fbjs
  module Uploaders
    class BaseUploader
	include YachtTransfer::Standards
      class LoginFailedError < StandardError;  end
      class FormNotFoundError < StandardError;  end
      class NoFormError < StandardError;  end
      class NotReadyError < StandardError;  end
      class NotImplementedError < StandardError;  end

      attr_accessor :username, :password, :listing

      def initialize(username, password, listing)
        @username = username
        @password = password
        @listing = listing
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

    end
  end
end
