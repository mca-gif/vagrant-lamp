require 'spec_helper'

describe Chef::Sugar::DataBag do
  describe '#encrypted_data_bag_item' do
    before { allow(Chef::EncryptedDataBagItem).to receive(:load) }

    it 'loads the encrypted data bag item' do
      expect(Chef::EncryptedDataBagItem).to receive(:load)
        .with('accounts', 'github', 'secret_key')

      described_class.encrypted_data_bag_item('accounts', 'github', 'secret_key')
    end

    context 'when Chef::Config is set' do
      it 'loads the secret key from the Chef::Config' do
        allow(Chef::Config).to receive(:[]).with(:encrypted_data_bag_secret).and_return('/data/path')
        allow(File).to receive(:read).with('/data/path').and_return('B@c0n')

        expect(Chef::EncryptedDataBagItem).to receive(:load)
          .with('accounts', 'github', 'B@c0n')

        described_class.encrypted_data_bag_item('accounts', 'github')
      end
    end

    context 'when Chef::Config is not set and no value is given' do
      it 'raises an exception' do
        expect {
          described_class.encrypted_data_bag_item('accounts', 'github')
        }.to raise_error(Chef::Sugar::DataBag::EncryptedDataBagSecretNotGiven)
      end
    end
  end

  describe '#encrypted_data_bag_item_for_environment' do
    let(:node) { double(:node, chef_environment: 'production') }

    context 'when the environment exists' do
      it 'loads the data from the environment' do
        allow(Chef::EncryptedDataBagItem).to receive(:load).and_return(
          'production' => {
            'username' => 'sethvargo',
            'password' => 'bacon',
          }
        )

        expect(described_class.encrypted_data_bag_item_for_environment(node, 'accounts', 'github', 'secret_key')).to eq(
          'password' => 'bacon',
          'username' => 'sethvargo',
        )
      end
    end

    context 'when the environment does not exist' do
      it 'loads the data from the default bucket' do
        allow(Chef::EncryptedDataBagItem).to receive(:load).and_return(
          'staging' => {
            'username' => 'sethvargo',
            'password' => 'bacon',
          },
          'default' => {
            'username' => 'schisamo',
            'password' => 'ham',
          }
        )

        expect(described_class.encrypted_data_bag_item_for_environment(node, 'accounts', 'github', 'secret_key')).to eq(
          'password' => 'ham',
          'username' => 'schisamo',
        )
      end
    end
  end
end
