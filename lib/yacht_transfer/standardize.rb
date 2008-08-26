module YachtTransfer
  module Standardize
    def standardize(standards)
      ans = {}
      standards.each { |key,value|
        ans.merge!({value=>send(key)})
      }
      ans
    end
    class Hash
      def transform_keys!(transformation_hash)
        transformation_hash.each_pair{|key, value| transform_key!(key, value)}
      end
  
      def transform_key!(old_key, new_key)
        swapkey!(new_key, old_key)
      end
  
      ### This method is lifted from Ruby Facets core
      def swapkey!( newkey, oldkey )
        self[newkey] = self.delete(oldkey) if self.has_key?(oldkey)
        self
      end

      def assert_valid_keys(*valid_keys)
        unknown_keys = keys - [valid_keys].flatten
        raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(", ")}") unless unknown_keys.empty?
      end    
    end
  end
end

