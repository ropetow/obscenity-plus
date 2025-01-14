#first test of the gem and rspec
require 'rails_helper'

RSpec.describe Dummy::BaseModel, type: :model do
  before do
    Obscenity.configure do |config|
      config.blacklist   = ["badword"]
      config.replacement = :stars
    end
  end

  it "validates profanity in the title" do
    model = Dummy::BaseModel.new(title: "This is a badword")
    expect(Obscenity.profane?(model.title)).to be true
    expect(Obscenity.sanitize(model.title)).to eq "This is a *******"
  end
end