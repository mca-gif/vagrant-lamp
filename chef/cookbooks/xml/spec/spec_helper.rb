require 'chefspec'
require 'berkshelf'

Berkshelf.ui.mute do
  Berkshelf::Berksfile.from_file('Berksfile').install(path: 'vendor/cookbooks')
end

RSpec.configure do |config|
  config.cookbook_path = 'vendor/cookbooks'
  config.platform = 'ubuntu'
  config.version = '12.04'
  config.log_level = :info
end
