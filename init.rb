# Include hook code here

require 'yacht_transfer'
require 'yacht_transfer/rails/controller'
require 'yacht_transfer/rails/helper'
require 'yacht_transfer/rails/model'

module ::ActionController
  class Base
    def self.inherited_with_yacht_transfer(subclass)
      inherited_without_yacht_transfer(subclass)
      if subclass.to_s == "ApplicationController"
        subclass.send(:include,YachtTransfer::Rails::Controller)
        subclass.helper YachtTransfer::Rails::Helper
      end
    end
    class << self
      alias_method_chain :inherited, :yacht_transfer
    end
  end
end

ActiveRecord::Base.send :include, YachtTransfer::Rails::Model
