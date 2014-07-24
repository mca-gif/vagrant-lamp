#
# Copyright 2013-2014, Seth Vargo <sethvargo@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Object
  # An object is blank if it's false, empty, or a whitespace string.
  # This is implemented in rails.
  #
  # @example foo.nil? || foo.empty? can be replaced by foo.blank?
  #
  # @return [true, false]
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end unless method_defined?(:blank?)
end
