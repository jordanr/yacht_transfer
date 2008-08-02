module YachtTransfer
  module Service    
    [:session_get, :listings_get].each { |call|
	define_method(call) { raise "not implemented yet" }
    }
	
    def post(params)
      send(params.delete(:method).gsub(/\./,'_'), params)
    end
  end
end
