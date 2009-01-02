require 'yacht_transfer/standards/base_standards'
module YachtTransfer
  module Rails
    module Model
      include YachtTransfer::Standards::BaseStandards
      def self.included(model)
        model.extend(ClassMethods)
	model.send(:include, YachtTransfer::Standards::BaseStandards)
      end

      def state; states[state_id-1]; end
      def country; countries[country_id-1]; end
      def status; statuses[status_id-1]; end
      def listing_type; listing_types[type_id-1]; end
      def currency; currencies[currency_id-1]; end
      def yacht_type; yacht_types[type_id-1]; end
      def hull_material; hull_materials[hull_material_id-1]; end
      def length_units; length_units[length_units_id-1]; end
      def weight_units; weight_units[weight_units_id-1]; end
      def volume_units; volume_units[volume_units_id-1]; end
      def speed_units; speed_units[speed_units_id-1]; end
      def fuel; fuels[engine_fuel_id-1]; end

      module ClassMethods
        def validates_state; validates_inclusion_of :state_id, :in => 1..states; end
        def validates_country; validates_inclusion_of :country_id, :in => 1..countries.length; end
        def validates_status; validates_inclusion_of :status_id, :in => 1..statuses.length; end
        def validates_listing_type; validates_inclusion_of :type_id, :in => 1..listing_types.length; end
        def validates_currency; validates_inclusion_of :currency_id, :in => 1..currencies.length; end
        def validates_yacht_type; validates_inclusion_of :type_id, :in => 1..yacht_types.length; end
        def validates_hull_material; validates_inclusion_of :hull_material_id, :in => 1..hull_materials.length; end
        def validates_length_units; validates_inclusion_of :length_units_id, :in => 1..length_units.length; end
        def validates_weight_units; validates_inclusion_of :weight_units_id, :in => 1..weight_units.length; end
        def validates_volume_units; validates_inclusion_of :volume_units_id, :in => 1..volume_units.length; end
        def validates_speed_units; validates_inclusion_of :speed_units_id, :in => 1..speed_units.length; end
        def validates_fuel; validates_inclusion_of :engine_fuel_id, :in => 1..fuels.length; end
      end
    end
  end
end
