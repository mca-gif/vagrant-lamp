require 'serverspec'
require 'pathname'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe file('/usr/ports/.portsnap.INDEX') do
  it { should be_file }
end
