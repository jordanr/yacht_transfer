require 'rexml/document'
require 'yacht_transfer/session'
module YachtTransfer
  class Parser
    
    module REXMLElementExtensions
      def text_value
        self.children.first.to_s.strip
      end
    end
    
    ::REXML::Element.__send__(:include, REXMLElementExtensions)
    
    def self.parse(method, data)
      Errors.process(data)
      parser = Parser::PARSERS[method]
      parser.process(
        data
      )
    end
    
    def self.array_of(response_element, element_name)
      values_to_return = []
      response_element.elements.each(element_name) do |element|
        values_to_return << yield(element)
      end
      values_to_return
    end
    
    def self.array_of_text_values(response_element, element_name)
      array_of(response_element, element_name) do |element|
        element.text_value
      end
    end

    def self.array_of_hashes(response_element, element_name)
      array_of(response_element, element_name) do |element|
        hashinate(element)
      end
    end
    
    def self.element(name, data)
      data = data.body rescue data # either data or an HTTP response
      doc = REXML::Document.new(data)
      doc.elements.each(name) do |element|
        return element
      end
      raise "Element #{name} not found in #{data}"
    end
    
    def self.hash_or_value_for(element)
      if element.children.size == 1 && element.children.first.kind_of?(REXML::Text)
        element.text_value
      else
        hashinate(element)
      end
    end
    
    def self.hashinate(response_element)
      response_element.children.reject{|c| c.kind_of? REXML::Text}.inject({}) do |hash, child|
        hash[child.name] = if child.children.size == 1 && child.children.first.kind_of?(REXML::Text)
          anonymous_field_from(child, hash) || child.text_value
        else
          if child.attributes['list'] == 'true'
            child.children.reject{|c| c.kind_of? REXML::Text}.map do |subchild| 
                hash_or_value_for(subchild)
            end     
          else
            child.children.reject{|c| c.kind_of? REXML::Text}.inject({}) do |subhash, subchild|
              subhash[subchild.name] = hash_or_value_for(subchild)
              subhash
            end
          end
        end
        hash
      end      
    end
    
    def self.anonymous_field_from(child, hash)
      if child.name == 'anon'
        (hash[child.name] || []) << child.text_value
      end
    end
    
  end  
  
  class CreateToken < Parser#:nodoc:
    def self.process(data)
      element('auth_createToken_response', data).text_value
    end
  end

  class GetSession < Parser#:nodoc:
    def self.process(data)      
      hashinate(element('auth_getSession_response', data))
    end
  end
  
  class GetListings < Parser#:nodoc:
    def self.process(data)
      array_of_text_values(element('friends_get_response', data), 'uid')
    end
  end
 
  class ListingInfo < Parser#:nodoc:
    def self.process(data)
      array_of_hashes(element('users_getInfo_response', data), 'user')
    end
  end
  
  class Errors < Parser#:nodoc:
    EXCEPTIONS = {
      1 	=> YachtTransfer::Session::UnknownError
    }
    def self.process(data)
      response_element = element('error_response', data) rescue nil
      if response_element
        hash = hashinate(response_element)
        raise EXCEPTIONS[Integer(hash['error_code'])].new(hash['error_msg'])
      end
    end
  end
  
  class Parser
    PARSERS = {
      'yt.auth.createToken' => CreateToken,
      'yt.auth.getSession' => GetSession,
      'yt.listing.getInfo' => ListingInfo,
      'yt.listings.get' => GetListings
    }
  end
end
