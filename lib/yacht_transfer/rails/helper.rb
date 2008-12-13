require 'yacht_transfer/standards'
module YachtTransfer
  module Rails
    module Helper
      include Std

      def state_select; select(:location, :state_id, options_with_ids(std::STATES)); end
      def country_select; select(:location, :country_id, options_with_ids(std::COUNTRIES)); end
      def status_select; select(:listing, :status_id, options_with_ids(std::STATUSES)); end
      def currency_select; select(:price, :currency_id, options_with_ids(std::CURRENCIES)); end
      def yacht_type_select; select(:specification, :type_id, options_with_ids(std::YACHT_TYPES)); end
      def hull_material_select;  select(:specification, :hull_material_id, options_with_ids(std::HULL_MATERIALS)); end
      def length_units_select;  select(:specification, :length_units_id, options_with_ids(std::LENGTH_UNITS)); end
      def weight_units_select;  select(:specification, :weight_units_id, options_with_ids(std::WEIGHT_UNITS)); end
      def volume_units_select;  select(:specification, :volume_units_id, options_with_ids(std::VOLUME_UNITS)); end
      def speed_units_select;  select(:specification, :speed_units_id, options_with_ids(std::SPEED_UNITS)); end
      def fuel_select;  select(:specification, :engine_fuel_id, options_with_ids(std::FUELS)); end

      private
        def options_with_ids(array)
          options = []
          array.each_with_index { |name,n|  options << [name,n+1] }
          options
        end
    end
  end
end
