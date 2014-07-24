This cookbook uses a variety of testing components:

- Unit tests: [ChefSpec](http://code.sethvargo.com/chefspec/)
- Integration tests: [Test Kitchen](http://kitchen.ci/)
- Chef Style lints: [Foodcritic](http://www.foodcritic.io/)
- Ruby Style lints: [Rubocop](https://github.com/bbatsov/rubocop)

You can install the [Chef Development Kit (Chef-DK)](http://downloads.getchef.com/chef-dk/) to more easily install the above components.


Prerequisites
-------------
To develop on this cookbook, you must have a sane Ruby 1.9+ environment. Given the nature of this installation process (and it's variance across multiple operating systems), we will leave this installation process to the user.

You must also have `bundler` installed:

    $ gem install bundler

You must also have Vagrant and VirtualBox installed:

- [Vagrant](https://vagrantup.com)
- [VirtualBox](https://virtualbox.org)


Development
-----------
1. Clone the git repository from GitHub:

        $ git clone git@github.com:onehealth-cookbooks/apache2.git

2. Install the dependencies using bundler:

        $ bundle install

3. Create a branch for your changes:

        $ git checkout -b my_bug_fix

4. Make any changes
5. Write tests to support those changes. It is highly recommended you write both unit and integration tests.
6. Run the tests:
    - `bundle exec rspec`
    - `bundle exec foodcritic .`
    - `bundle exec rubocop`
    - `bundle exec kitchen test`

7. Assuming the tests pass, open a Pull Request on GitHub

For more information, see [OneHealth's Contribution Guidelines](https://github.com/onehealth-cookbooks/apache2/blob/master/CONTRIBUTING.md)
