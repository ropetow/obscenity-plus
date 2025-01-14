#config_spec.rb
require 'spec_helper'
require 'obscenity/config'

RSpec.describe Obscenity::Config do
  describe '#respond_to?' do
    it 'responds to expected methods and attributes' do
      config = Obscenity::Config.new
      [:blacklist, :whitelist, :replacement].each do |field|
        expect(config).to respond_to(field)
      end
    end
  end

  describe 'configuration parameters' do
    it 'properly sets config parameters' do
      blacklist = ['ass', 'shit', 'penis']
      whitelist = ['penis']
      replacement = :stars

      config = Obscenity::Config.new do |c|
        c.blacklist = blacklist
        c.whitelist = whitelist
        c.replacement = replacement
      end

      expect(config.blacklist).to eq(blacklist)
      expect(config.whitelist).to eq(whitelist)
      expect(config.replacement).to eq(replacement)
    end

    it 'returns default values if none are set' do
      config = Obscenity::Config.new
      expect(config.whitelist).to eq([])
      expect(config.replacement).to eq(:garbled)
      expect(config.blacklist.to_s).to match(/config\/blacklist.yml/)
    end

    it 'returns default values when explicitly set to default' do
      config = Obscenity::Config.new do |c|
        c.blacklist = :default
        c.replacement = :default
      end

      expect(config.whitelist).to eq([])
      expect(config.replacement).to eq(:default)
      expect(config.blacklist.to_s).to match(/config\/blacklist.yml/)
    end
  end

  describe 'validating configuration options' do
    it 'raises exceptions for invalid config options' do
      invalid_values = [
        [Obscenity::UnkownContent, {}],
        [Obscenity::UnkownContent, ":unkown"],
        [Obscenity::EmptyContentList, []],
        [Obscenity::UnkownContentFile, "'path/to/file'"],
        [Obscenity::UnkownContentFile, Pathname.new("'path/to/file'")]
      ]

      [:blacklist, :whitelist].each do |field|
        invalid_values.each do |klass, value|
          expect {
            Obscenity::Config.new do |config|
              config.instance_eval("config.#{field} = #{value}")
            end
          }.to raise_error(klass)
        end
      end
    end
  end
end
