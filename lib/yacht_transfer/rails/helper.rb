require 'yacht_transfer/standards/base_standards'
module YachtTransfer
  module Rails
    module Helper
      include YachtTransfer::Standards::BaseStandards

#      def status_select; select(:listing, :status_id, options_with_ids(statuses)); end
#      def listing_type_select; select(:listing, :type_id, options_with_ids(listing_types)); end
#      def currency_select; select(:price, :currency_id, options_with_ids(currencies)); end
#      def yacht_type_select; select(:specification, :type_id, options_with_ids(yacht_types)); end
#      def hull_material_select;  select(:specification, :hull_material_id, options_with_ids(hull_materials)); end
#      def fuel_select;  select(:specification, :engine_fuel_id, options_with_ids(fuels)); end

      def mls_select; select(:account, :mls_id, options_with_ids(mlses)); end

      private

        def mlses
	  %w{ YachtWorld YachtCouncil }
	end

        def options_with_ids(array)
          options = []
          array.each_with_index { |name,n|  options << [name,n+1] }
          options
        end
    end
  end
end
