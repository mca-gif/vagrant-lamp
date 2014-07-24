require 'spec_helper'

describe Chef::Sugar::Shell do
  describe '#which' do
    it 'returns the first executable matching the command' do
      allow(File).to receive(:executable?).and_return(false)
      allow(File).to receive(:executable?).with('/usr/bin/mongo').and_return(true)
      expect(described_class.which('mongo')).to eq('/usr/bin/mongo')
    end

    it 'returns nil when no command is found' do
      allow(File).to receive(:executable?).and_return(false)
      expect(described_class.which('node')).to be_nil
    end

    context 'with an absolute path' do
      it 'returns the executable if it exists' do
        allow(File).to receive(:executable?).with('/usr/local/bin/bash').and_return(true)
        expect(described_class.which('/usr/local/bin/bash')).to eq('/usr/local/bin/bash')
      end

      it 'returns nil when the file is not executable' do
        allow(File).to receive(:executable?).with('/usr/local/bin/bash').and_return(false)
        expect(described_class.which('/usr/local/bin/bash')).to be_nil
      end
    end
  end

  describe '#dev_null' do
    it 'returns NUL on Windows' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.dev_null(node)).to eq('NUL')
    end

    it 'returns /dev/null on Linux' do
      node = { 'platform_family' => 'debian' }
      expect(described_class.dev_null(node)).to eq('/dev/null')
    end
  end

  describe '#installed?' do
    it 'returns true if the given binary exists' do
      allow(described_class).to receive(:which).and_return(nil)
      allow(described_class).to receive(:which).with('mongo').and_return(true)
      expect(described_class.installed?('mongo')).to be_truthy
    end

    it 'returns false if the given binary does not exist' do
      allow(File).to receive(:executable?).and_return(false)
      expect(described_class.installed?('node')).to be_falsey
    end
  end

  describe '#installed_at_version?' do
    it 'returns true if the command is installed at the correct version' do
      allow(described_class).to receive(:which).and_return(true)
      allow(described_class).to receive(:version_for).and_return('1.2.3')
      expect(described_class.installed_at_version?('mongo', '1.2.3')).to be_truthy
    end

    it 'returns true if the command is installed at the correct version and has additional output' do
      allow(described_class).to receive(:which).and_return(true)
      allow(described_class).to receive(:version_for).and_return('Mongo DB version 1.2.3. Some other text.')
      expect(described_class.installed_at_version?('mongo', '1.2.3')).to be_truthy
    end

    it 'returns true if the command is installed at the correct version with a regex' do
      allow(described_class).to receive(:which).and_return(true)
      allow(described_class).to receive(:version_for).and_return('1.2.3')
      expect(described_class.installed_at_version?('mongo', /1\.2/)).to be_truthy
    end

    it 'returns false if the command is installed at the wrong version' do
      allow(described_class).to receive(:which).and_return(true)
      allow(described_class).to receive(:version_for).and_return('1.2.3')
      expect(described_class.installed_at_version?('mongo', '4.5.6')).to be_falsey
    end

    it 'returns false if the command is not installed' do
      allow(described_class).to receive(:which).and_return(nil)
      expect(described_class.installed_at_version?('mongo', '1.0.0')).to be_falsey
    end
  end

  describe '#version_for' do
    let(:shell_out) { double('shell_out', run_command: nil, error!: nil, stdout: '1.2.3', stderr: 'Oh no!') }
    before { allow(Mixlib::ShellOut).to receive(:new).and_return(shell_out) }

    it 'runs the thing in shellout' do
      expect(Mixlib::ShellOut).to receive(:new).with('mongo --version')
      described_class.version_for('mongo')
    end

    it 'returns the combined stdout and stderr' do
      expect(described_class.version_for('mongo')).to eq("1.2.3\nOh no!")
    end
  end
end
