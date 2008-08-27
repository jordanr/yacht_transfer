module YachtTransfer
  module Models
    class Country
      def self.hash
        countries_from_file = YAML::load(File.open(File.dirname(__FILE__) + "/countries.yml"))
      end
     
      def self.options
	self.hash.collect { |c| c.values }.flatten
      end
    end
  end
end
