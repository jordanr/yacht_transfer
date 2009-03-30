require 'yacht_transfer/standards/base_standards'
module YachtTransfer
  module Rails
    module Model
      include YachtTransfer::Standards::BaseStandards
      def self.included(model)
        model.extend(ClassMethods)
	model.send(:include, YachtTransfer::Standards::BaseStandards)
      end

      def status; statuses[status_id-1]; end
      def listing_type; listing_types[type_id-1]; end
      def currency; currencies[currency_id-1]; end
      def yacht_type; yacht_types[type_id-1]; end
      def hull_material; hull_materials[hull_material_id-1]; end
      def fuel; fuels[engine_fuel_id-1]; end

      module ClassMethods
        def validates_status; validates_inclusion_of :status_id, :in => 1..statuses.length; end
        def validates_listing_type; validates_inclusion_of :type_id, :in => 1..listing_types.length; end
        def validates_currency; validates_inclusion_of :currency_id, :in => 1..currencies.length; end
        def validates_yacht_type; validates_inclusion_of :type_id, :in => 1..yacht_types.length; end
        def validates_hull_material; validates_inclusion_of :hull_material_id, :in => 1..hull_materials.length; end
        def validates_fuel; validates_inclusion_of :engine_fuel_id, :in => 1..fuels.length; end
      end
    end
  end
end
