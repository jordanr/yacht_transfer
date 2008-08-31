require 'yacht_transfer/model'
require 'yacht_transfer/standards'
module YachtTransfer
  module Models
    class Engine
      include Model, Std

      attr_accessor :manufacturer, :model
      attr_reader :horsepower, :year, :hours, :fuel
      type_checking_attr_writer *[:horsepower, :hours].push(Numeric)
      option_checking_attr_writer :year, 1000..9999
      option_checking_attr_writer :fuel, std::FUEL_TRANSFORM.keys

    end
  end
end
