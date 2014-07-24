#
# Copyright (c) 2014 OneHealth Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require "#{ENV['BUSSER_ROOT']}/../kitchen/data/serverspec_helper"

describe 'apache2::god_monitor' do

  describe service('god') do
    xit { should be_running   }
  end

  describe file('/etc/god/conf.d/apache2.god') do
    xit { should be_file }
  end

  # starts an apache2 sevice that works like a regular service
  # to be implemented when COOK-744 is fixed
end
