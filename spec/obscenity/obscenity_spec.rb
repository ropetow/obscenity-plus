#obscenity_spec.rb
require 'spec_helper'
require 'obscenity'

RSpec.describe Obscenity do
  before do
    Obscenity.configure do |config|
      config.blacklist = :default
      config.replacement = :garbled
    end
  end

  describe "respond_to?" do
    it "responds to the expected methods and attributes" do
      [:configure, :config, :profane?, :sanitize, :offensive, :replacement].each do |field|
        expect(Obscenity).to respond_to(field)
      end
    end
  end

  describe ".configure" do
    it "accepts a configuration block without raising errors" do
      expect {
        Obscenity.configure do |config|
          config.blacklist = :default
          config.replacement = :garbled
        end
      }.not_to raise_error
    end
  end

  describe ".config" do
    it "returns the current configuration object" do
      expect(Obscenity.config).not_to be_nil
    end
  end

  describe ".profane?" do
    it "validates the profanity of the given content" do
      expect(Obscenity.profane?('Yo, check that ass out')).to be true
      expect(Obscenity.profane?('Hello world')).to be false
    end
  end

  describe ".sanitize" do
    it "sanitizes the given content" do
      expect(Obscenity.sanitize('Yo, check that ass out')).to eq("Yo, check that $@!#% out")
      expect(Obscenity.sanitize('Hello world')).to eq("Hello world")
    end
  end

  describe ".offensive" do
    it "returns the offensive words for the given content" do
      expect(Obscenity.offensive('Yo, check that ass biatch')).to eq(['ass', 'biatch'])
      expect(Obscenity.offensive('Hello world')).to eq([])
    end
  end

  describe ".replacement" do
    it "sanitizes the given content based on the replacement method" do
      expect(Obscenity.replacement(:garbled).sanitize('Yo, check that ass out')).to eq("Yo, check that $@!#% out")
      expect(Obscenity.replacement(:default).sanitize('Yo, check that ass out')).to eq("Yo, check that $@!#% out")
      expect(Obscenity.replacement(:vowels).sanitize('Yo, check that ass out')).to eq("Yo, check that *ss out")
      expect(Obscenity.replacement(:nonconsonants).sanitize('Yo, check that 5hit out')).to eq("Yo, check that *h*t out")
      expect(Obscenity.replacement(:stars).sanitize('Yo, check that ass out')).to eq("Yo, check that *** out")
      expect(Obscenity.replacement("[censored]").sanitize('Yo, check that ass out')).to eq("Yo, check that [censored] out")
      expect(Obscenity.sanitize('Hello world')).to eq("Hello world")
    end
  end
end
