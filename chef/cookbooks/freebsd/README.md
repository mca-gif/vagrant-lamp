freebsd Cookbook
================

Handles FreeBSD-specific features and quirks.

Requirements
------------

Tested on FreeBSD 7.2, 8.0, 8.1, 8.2 and 9.0.

Attributes
----------

Usage
-----
#### freebsd::portsnap

This recipe ensures the Ports Collection collection is fully up to date.

This recipe should appear first in the run list of FreeBSD nodes to ensure that
the package cache is up to date before managing any `package` resources with
Chef.

Resources/Providers
-------------------

### port_options

Provides an easy way to set port options from within a cookbook.

It can be used in two different ways:

* template-based: specifying a source will write it to the correct destination with no change;
* options hash: if a options hash is passed instead, it will be merged on top of default and current options, and the result will be written back.

Note that the options hash take simple options names as keys and a boolean as value; when saving
to file, this is converted to the format that FreeBSD ports expect:

Option Key Name | Option Value | Options File
--------------- |------------- |-------------
APACHE          | true         | WITH_APACHE=true
APACHE          | false        | WITHOUT_APACHE=true

#### Actions
Action  | Description                                                 | Default
------- |-------------                                                |---------
create  | create the port options file according to the given options | Yes


#### Attributes
Attribute   | Description
-------     |-------------
name        | The name of the port whose options file you want to manipulate;
source      | if the attribute is set, it will be used to look up a template, which will then be saved as a port options file
options     | a hash with the option name as the key, and a boolean as value.

#### Examples

```ruby
# freebsd-php5-options will be written out as /var/db/ports/php5/options
freebsd_port_options "php5" do
  source "freebsd-php5-options.erb"
  action :create
end

# Default options will be read from /usr/ports/lang/php5;
# current options from /var/db/ports/php5/options (if exists);
# the APACHE options will be set to true, the others will be unchanged
freebsd_port_options "php5" do
  options "APACHE" => true
  action :create
end
```

License and Authors
-------------------

Author:: Andrea Campi (<andrea.campi@zephirworks.com>)
Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright 2010-2012, ZephirWorks
Copyright 2013, Opscode, Inc. (<legal@opscode.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
