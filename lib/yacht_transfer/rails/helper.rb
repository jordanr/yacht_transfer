require 'yacht_transfer/standards/base_standards'
module YachtTransfer
  module Rails
    module Helper
      include YachtTransfer::Standards::BaseStandards

      def state_select; select(:location, :state_id, options_with_ids(states)); end
      def country_select; select(:location, :country_id, options_with_ids(countries)); end
      def status_select; select(:listing, :status_id, options_with_ids(statuses)); end
      def listing_type_select; select(:listing, :type_id, options_with_ids(listing_types)); end
      def currency_select; select(:price, :currency_id, options_with_ids(currencies)); end
      def yacht_type_select; select(:specification, :type_id, options_with_ids(yacht_types)); end
      def hull_material_select;  select(:specification, :hull_material_id, options_with_ids(hull_materials)); end
      def length_units_select;  select(:specification, :length_units_id, options_with_ids(length_units)); end
      def weight_units_select;  select(:specification, :weight_units_id, options_with_ids(weight_units)); end
      def volume_units_select;  select(:specification, :volume_units_id, options_with_ids(volume_units)); end
      def speed_units_select;  select(:specification, :speed_units_id, options_with_ids(speed_units)); end
      def fuel_select;  select(:specification, :engine_fuel_id, options_with_ids(fuels)); end

      private
        def options_with_ids(array)
          options = []
          array.each_with_index { |name,n|  options << [name,n+1] }
          options
        end
    end
  end
end
