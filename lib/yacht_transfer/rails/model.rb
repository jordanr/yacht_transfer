require 'yacht_transfer/standards'
module YachtTransfer
  module Rails
    module Model
      include Std
      def self.included(model)
        model.extend(ClassMethods)
	model.send(:include, Std)
      end

      def state; std::STATES[state_id-1]; end
      def country; std::COUNTRIES[country_id-1]; end
      def status; std::STATUSES[status_id-1]; end
      def currency; std::CURRENCIES[currency_id-1]; end
      def type; std::YACHT_TYPES[type_id-1]; end
      def hull_material; std::HULL_MATERIALS[hull_material_id-1]; end
      def length_units; std::LENGTH_UNITS[length_units_id-1]; end
      def weight_units; std::WEIGHT_UNITS[weight_units_id-1]; end
      def volume_units; std::VOLUME_UNITS[volume_units_id-1]; end
      def speed_units; std::SPEED_UNITS[speed_units_id-1]; end
      def fuel; std::FUELS[engine_fuel_id-1]; end

      module ClassMethods
        def validates_state; validates_inclusion_of :state_id, :in => 1..std::STATES.length; end
        def validates_country; validates_inclusion_of :country_id, :in => 1..std::COUNTRIES.length; end
        def validates_status; validates_inclusion_of :status_id, :in => 1..std::STATUSES.length; end
        def validates_currency; validates_inclusion_of :currency_id, :in => 1..std::CURRENCIES.length; end
        def validates_yacht_type; validates_inclusion_of :type_id, :in => 1..std::YACHT_TYPES.length; end
        def validates_hull_material; validates_inclusion_of :hull_material_id, :in => 1..std::HULL_MATERIALS.length; end
        def validates_length_units; validates_inclusion_of :length_units_id, :in => 1..std::LENGTH_UNITS.length; end
        def validates_weight_units; validates_inclusion_of :weight_units_id, :in => 1..std::WEIGHT_UNITS.length; end
        def validates_volume_units; validates_inclusion_of :volume_units_id, :in => 1..std::VOLUME_UNITS.length; end
        def validates_speed_units; validates_inclusion_of :speed_units_id, :in => 1..std::SPEED_UNITS.length; end
        def validates_fuel; validates_inclusion_of :engine_fuel_id, :in => 1..std::FUELS.length; end
      end
    end
  end
end
