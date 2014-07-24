require 'serverspec'
require 'pathname'

include Serverspec::Helper::Exec

# Ensure GCC exists
describe command('gcc --version') do
  it { should return_exit_status 0 }
end

# On FreeBSD `make` is actually BSD make
gmake_bin = if RUBY_PLATFORM =~ /freebsd/
              'gmake'
            else
              'make'
            end

# Ensure GNU Make exists
describe command("#{gmake_bin} --version") do
  it { should return_exit_status 0 }
  it { should return_stdout(/GNU/) }
end
