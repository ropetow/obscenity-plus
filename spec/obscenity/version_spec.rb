require 'spec_helper'

RSpec.describe Obscenity do
  it "returns the correct product version" do
    expect(Obscenity::VERSION).to eq('1.0.2')
  end
end
