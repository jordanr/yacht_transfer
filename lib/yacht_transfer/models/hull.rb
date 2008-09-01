require 'yacht_transfer/model'
require 'yacht_transfer/standards'
module YachtTransfer
  module Models
    class Hull
      include Model, Std
      attr_accessor :configuration, :color, :designer
      attr_reader :material
      option_checking_attr_writer :material, std::MATERIAL_TRANSFORM.keys
    end
  end
end
