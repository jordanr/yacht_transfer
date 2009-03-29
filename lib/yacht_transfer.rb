# YachtTransfer
require 'yacht_transfer/rails/controller.rb'
require 'yacht_transfer/rails/helper.rb'
require 'yacht_transfer/rails/model.rb'

require 'yacht_transfer/standards/base_standards'
require 'yacht_transfer/standards/yacht_council_standards'
require 'yacht_transfer/standards/yacht_world_standards'

require 'yacht_transfer/transferers/abstract_transferer'
require 'yacht_transfer/transferers/yacht_council_transferer'
require 'yacht_transfer/transferers/yacht_world_transferer'

require 'yacht_transfer/version'

module YachtTransfer
end
