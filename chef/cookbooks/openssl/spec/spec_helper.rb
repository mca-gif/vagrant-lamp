require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation
end
