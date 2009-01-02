require 'yacht_transfer/model'
require 'yacht_transfer/standards/base_standards'
module YachtTransfer
  module Models
    class Hull
      include Model, YachtTransfer::Standards::BaseStandards
      attr_accessor :configuration, :color, :designer
      attr_reader :material
      option_checking_attr_writer :material, hull_materials #std::MATERIAL_TRANSFORM.keys
    end
  end
end
