module YachtTransfer
  module Models
    class State
      def self.load
        @states_from_file = YAML::load(File.open(File.dirname(__FILE__) + "/states.yml"))
      end
   
      def self.data
	@states_from_file || self.load
      end

      def self.abbreviation(name)
	return name if self.abbreviations.include?(name)
	state = self.data.find { |c| c[:name]==name }
	state[:a]
      end

      def self.name(abbreviation)
	return abbreviation if self.names.include?(name)
	state = self.data.find { |c| c[:a]==abbreviation }
	state[:name]
      end

      def self.names
        self.data.collect { |c| c[:name] }
      end

      def self.abbreviations
        self.data.collect { |c| c[:a] }
      end

      def self.options
        self.data.collect { |c| c.values }.flatten
      end
    end
  end
end
