require 'yacht_transfer/model'
require 'yacht_transfer/models/listing'
module YachtTransfer
  module Models
    class User
      include Model

      attr_accessor :username, :password, :session

      # Can pass in these two forms:
      # id, session, (optional) attribute_hash
      # attribute_hash
#      def initialize(*args)
#        if (args.first.kind_of?(String) || args.first.kind_of?(Integer)) && args.size==1
#          @id=Integer(args.shift)
#          @session = Session.current
#        elsif (args.first.kind_of?(String) || args.first.kind_of?(Integer)) && args[1].kind_of?(Session)
#          @id = Integer(args.shift)
#          @session = args.shift
#        end
#        if args.last.kind_of?(Hash)
#          populate_from_hash!(args.pop)
#        end
#      end


      # only get minimum information
      def listings
   	#session.post('listings.get')
      end

      # get populated listings
      def listings!
   	#session.post('listing.get', :lids => listings.map { |l| l.id } )
      end

      def upload_listing(listing)
	#session.post('listing.post', listing.fields)
      end
    end
  end
end
