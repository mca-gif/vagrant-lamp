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

describe 'apache2::mod_python' do
  expected_module = 'python'
  subject(:available) { file("#{property[:apache][:dir]}/mods-available/#{expected_module}.load") }
  it "mods-available/#{expected_module}.load is accurate" do
    expect(available).to be_file
    expect(available).to be_mode 644
    expect(available.content).to match "LoadModule #{expected_module}_module #{property[:apache][:libexec_dir]}/mod_#{expected_module}.so\n"
  end

  subject(:enabled) { file("#{property[:apache][:dir]}/mods-enabled/#{expected_module}.load") }
  it "mods-enabled/#{expected_module}.load is a symlink to mods-available/#{expected_module}.load" do
    # rspec3 syntax
    # is_expected.to be_linked_to("#{property[:apache][:dir]}/mods-available/#{expected_module}.load").or be_linked_to("../mods-available/#{expected_module}.load")
    os = backend.check_os
    if os[:family] == 'RedHat'
      expect(enabled).to be_linked_to("#{property[:apache][:dir]}/mods-available/#{expected_module}.load")
    else
      expect(enabled).to be_linked_to("../mods-available/#{expected_module}.load")
    end
  end

  subject(:loaded_modules) { command("#{property[:apache][:binary]} -M") }
  it "#{expected_module} is loaded" do
    expect(loaded_modules).to return_exit_status 0
    expect(loaded_modules).to return_stdout(/#{expected_module}_module/)
  end
end
