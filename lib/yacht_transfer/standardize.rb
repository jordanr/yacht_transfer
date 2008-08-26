module YachtTransfer
  module Standardize
    def standardize(standards)
      ans = {}
      standards.each { |key,value|
        ans.merge!({value=>send(key)})
      }
      ans
    end
  end
end

