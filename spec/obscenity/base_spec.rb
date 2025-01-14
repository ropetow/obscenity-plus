#base_spec.rb
require 'spec_helper'
require 'obscenity'

RSpec.describe Obscenity::Base do
  before do
    Obscenity.configure do |config|
      config.blacklist = ["badword", "foulword"]
      config.whitelist = ["safe"]
      config.replacement = :stars
    end
  end

  describe "responding to methods" do
    it "responds to expected methods" do
      [:blacklist, :whitelist, :profane?, :sanitize, :replacement, :offensive, :replace].each do |method|
        expect(Obscenity::Base).to respond_to(method)
      end
    end
  end

  describe "#profane?" do
    it "detects profane words" do
      expect(Obscenity::Base.profane?("badword")).to be true
    end

    it "does not detect clean words as profane" do
      expect(Obscenity::Base.profane?("cleanword")).to be false
    end
  end

  describe "#sanitize" do
    it "replaces profane words with stars" do
      expect(Obscenity::Base.sanitize("badword")).to eq("*******")
    end

    it "returns clean words unchanged" do
      expect(Obscenity::Base.sanitize("cleanword")).to eq("cleanword")
    end
  end
end
