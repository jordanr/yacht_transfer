require 'yacht_transfer/model'
require 'yacht_transfer/standardize'
module YachtTransfer
  module Models
    class Hull
      include Model,Standardize
      attr_accessor :configuration, :material, :color, :designer

      def to_yw
	standardize(STD2YW)
      end

      private
	STD2YW = {:designer=>"designer", :material=>"hull_material"}
    end
  end
end
