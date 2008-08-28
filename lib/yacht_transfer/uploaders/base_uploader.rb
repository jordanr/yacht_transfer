require "rubygems"
require "mechanize"
module Js2Fbjs
  module Uploaders
    class BaseUploader
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

      def forage(codeword, url=nil)
	login if !logged_on?
	@form = get_form(url ? agent.get(url) : agent.current_page, codeword)
      end

      def basic
        raise NoFormError, "you must forage first" unless @form
        fill_out_form!(@form, listing.to_yw)
      end
      
      def error(errorword, codeword, fix, keyword=nil)
	raise NotReadyError, "no page to error check" unless agent.current_page
	if(agent.current_page.root.to_html.match(errorword))
	  forage(codeword)
	  fill_out_form!(@form, fix)
	  resp = submit(keyword)
          if(resp.root.to_html.match(errorword))
  	    raise ErrorFixFailed, "could not get rid of #{errorword}" 
          end
	  resp
        end
      end

      def submit(codeword=nil)
	raise NoFormError, "you need to forage first" unless @form
	resp = @form.submit(codeword) 
	@form = nil # form is not ready again
	resp
      end

#      private
      def logged_on?
	@logged_on
      end

      def agent
        @agent ||= WWW::Mechanize.new
      end

      def login
        raise NotImplementedError, "subclass should have overriden"
      end

      def fill_out_form!(form, hash)
	inputs_to_fill = hash.delete_if { |k,v|
				!form.has_input?(k.to_s)
			 }
	inputs_to_fill.each_pair { |k,v| inputs_to_fill[k]=v.to_s }
	form.set_inputs(inputs_to_fill)
	form
      end
 
      def names(inputs)
	inputs.map { |f| f.name }
      end
      
      def get_form(page, codeword)
	page.forms.each { |f|
	  if f.has_input?(codeword)
	    return f
	  end
	}
	raise FormNotFoundError, "looking for #{codeword}"
      end

    end
  end
end
