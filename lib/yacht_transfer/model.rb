module YachtTransfer
  ##
  # helper methods primarily supporting the management of Ruby objects which are populatable via Hashes.  
  # Since most calls accept and return hashes of data, the Model module allows us to
  # directly populate a model's attributes given a Hash with matching key names.
  module Model
    class UnboundSessionException < Exception; end
    def self.included(includer)
      includer.extend ClassMethods
      includer.__send__(:attr_writer, :session)
      includer.__send__(:attr_reader, :anonymous_fields)
    end
    module ClassMethods
      ##
      # Instantiate a new instance of the class into which we are included and populate that instance's
      # attributes given the provided Hash.  Key names in the Hash should map to attribute names on the model.
      def from_hash(hash)
        instance = new(hash)
        yield instance if block_given?
        instance
      end
      
      ##
      # Create a standard attr_writer and a populating_attr_reader      
      def populating_attr_accessor(*symbols)
        attr_writer *symbols
        populating_attr_reader *symbols
      end

      ## 
      # Create a reader that will attempt to populate the model if it has not already been populated
      def populating_attr_reader(*symbols)
        symbols.each do |symbol|
          define_method(symbol) do
            populate unless populated?
            instance_variable_get("@#{symbol}")
          end
        end
      end
      
      def populating_hash_settable_accessor(*symbols)
	klass = symbols.pop
        populating_attr_reader *symbols
	symbols.push(klass)
        hash_settable_writer *symbols
      end
        
      def populating_hash_settable_list_accessor(symbol, klass)
        populating_attr_reader symbol
        hash_settable_list_writer(symbol, klass)
      end
      
      #
      # Declares an attribute named ::symbol:: which can be set with either an instance of ::klass::
      # or a Hash which will be used to populate a new instance of ::klass::.
      def hash_settable_accessor(symbol, klass)
        attr_reader symbol
        hash_settable_writer(symbol, klass)
      end
      
      def hash_settable_writer(*symbols)
        klass = symbols.pop
        symbols.each do |symbol|
          define_method("#{symbol}=") do |value|
            instance_variable_set("@#{symbol}", value.kind_of?(Hash) ? klass.from_hash(value) : value)
          end        
        end
      end
      
      #
      # Declares an attribute named ::symbol:: which can be set with either a list of instances of ::klass::
      # or a list of Hashes which will be used to populate a new instance of ::klass::.      
      def hash_settable_list_accessor(symbol, klass)
        attr_reader symbol
        hash_settable_list_writer(symbol, klass)
      end
      
      def hash_settable_list_writer(symbol, klass)
        define_method("#{symbol}=") do |list|
          instance_variable_set("@#{symbol}", list.map do |item|
            item.kind_of?(Hash) ? klass.from_hash(item) : item
          end)
        end
      end      

      def type_checking_attr_writer(*symbols)
	klass = symbols.pop
	symbols.each do |symbol|
          define_method("#{symbol}=") do |value|
            raise TypeError, "'#{value}' should be #{klass.name}" unless value.is_a?(klass)
            instance_variable_set("@#{symbol}", value)
          end
        end
      end

      def validating_attr_writer(*symbols)
	list = symbols.pop
	symbols.each do |symbol|
          define_method("#{symbol}=") do |value|
            raise RangeError, "'#{value}' should be one of #{list}" unless list.include?(value)
            instance_variable_set("@#{symbol}", value)
          end
        end
      end
    end

    
    ##
    # Centralized, error-checked place for a model to get the session to which it is bound.
    # Any queries require a Session instance.
    def session
      @session || (raise UnboundSessionException, "Must bind this object to a session before querying")
    end
    
    # 
    # This gets populated from FQL queries.
    def anon=(value)
      @anonymous_fields = value
    end
    
    def initialize(hash = {})
      populate_from_hash!(hash)
    end

    def populate
      raise NotImplementedError, "#{self.class} included me and should have overriden me"
    end

    def populated?
      !@populated.nil?
    end
    
    ##
    # Set model's attributes via Hash.  Keys should map directly to the model's attribute names.
    def populate_from_hash!(hash)
      unless hash.empty?
        hash.each do |key, value|
          self.__send__("#{key}=", value)
        end
        @populated = true
      end      
    end    
  end
end
