module YachtTransfer
  module Service    
    def self.included(mls)
      mls.extend(ClassMethods)
    end

    module ClassMethods
      def post(params)
        self.send(params.delete(:method).gsub(/\./,'_'), params)
      end
    end
  end
end
