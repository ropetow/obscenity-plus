#spec/validators/obscenity_validator_spec.rb
# test to ensure that the ObscenityValidator is working as expected
require 'spec_helper'

RSpec.describe ActiveModel::Validations::ObscenityValidator do
    before do
        Obscenity.configure do |config|
            config.blacklist = ["badword"]
            config.whitelist = []
            config.replacement = :stars
        end
    end

    let(:dummy_class) do
        Class.new do
            include ActiveModel::Validations
            attr_accessor :title, :content
            validates :title, obscenity: true
            validates :content, obscenity: { sanitize: true, replacement: '[censored]' }
        end
    end

    let(:dummy_instance) { dummy_class.new }

    context "when validating profanity" do
        it "adds an error message when profane" do
            dummy_instance.title = "This is a badword"
            expect(dummy_instance.valid?).to be false
            expect(dummy_instance.errors[:title]).to include("cannot be profane")
        end

        it "does not add an error for clean words" do
            dummy_instance.title = "This is clean"
            expect(dummy_instance.valid?).to be true
          end
        end
      
        context "when sanitizing profanity" do
          it "sanitizes profane words" do
            dummy_instance.content = "This is a badword"
            expect(dummy_instance.valid?).to be true
            expect(dummy_instance.content).to eq("This is a [censored]")
          end
      
          it "leaves clean words unchanged" do
            dummy_instance.content = "This is clean"
            expect(dummy_instance.valid?).to be true
            expect(dummy_instance.content).to eq("This is clean")
          end
        end
      end