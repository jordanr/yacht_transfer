require "rubygems"
require "mechanize"
module Js2Fbjs
  module Uploaders
    class BaseUploader
      class LoginFailedError < StandardError;  end
      class FormNotFoundError < StandardError;  end
      class NotImplementedError < StandardError;  end

      attr_reader :username, :password

      def initialize(username, password)
        @username = username
        @password = password
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

      def forage(url, codeword)
	login if !logged_on?
	@form = get_form(agent.get(url), codeword)
      end
	
      def get_form(page, codeword)
	page.forms.each { |f|
	  return f if f.has_field?(codeword)
	}
	raise FormNotFoundError, "looking for #{codeword}"
      end
    end
  end
end
