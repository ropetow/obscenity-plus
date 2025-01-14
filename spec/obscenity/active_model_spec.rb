#active_model_spec.rb
require 'spec_helper'
require 'active_model'
require 'obscenity'
require 'obscenity/active_model'

RSpec.describe "ActiveModel Obscenity Validation" do
  before do
    Obscenity.configure do |config|
      config.blacklist = ["shits"]
      config.replacement = :stars
    end
  end

  let(:generate_new_class) do
    ->(name, options = {}) do
      klass_name = "Dummy::#{name}"
      Object.send(:remove_const, klass_name) if Object.const_defined?(klass_name)
      Class.new do
        include ActiveModel::Validations
        attr_accessor :title

        validates :title, options

        def initialize(attributes = {})
          attributes.each { |key, value| send("#{key}=", value) }
        end
      end
    end
  end

  context "when title is profane" do
    it "is invalid and adds an error message" do
      klass = generate_new_class.call("Post", obscenity: true)
      post = klass.new(title: "He who poops, shits itself")

      expect(post.valid?).to be false
      expect(post.errors).to have_key(:title)
      expect(post.errors[:title]).to include("cannot be profane")
    end

    it "includes a custom error message for profanity" do
      klass = generate_new_class.call("Post", obscenity: { message: "can't be profane!" })
      post = klass.new(title: "He who poops, shits itself")

      expect(post.valid?).to be false
      expect(post.errors).to have_key(:title)
      expect(post.errors[:title]).to include("can't be profane!")
    end
  end

  context "when sanitizing the title" do
    it "uses the default replacement method" do
      klass = generate_new_class.call("Post", obscenity: { sanitize: true })
      post = klass.new(title: "He who poops, shits itself")

      expect(post.valid?).to be true
      expect(post.errors).not_to have_key(:title)
      expect(post.title).to eq("He who poops, ***** itself")
    end

    it "uses the :garbled replacement method" do
      klass = generate_new_class.call("Post", obscenity: { sanitize: true, replacement: :garbled })
      post = klass.new(title: "He who poops, shits itself")

      expect(post.valid?).to be true
      expect(post.errors).not_to have_key(:title)
      expect(post.title).to eq("He who poops, $@!#% itself")
    end

    it "uses the :stars replacement method" do
      klass = generate_new_class.call("Post", obscenity: { sanitize: true, replacement: :stars })
      post = klass.new(title: "He who poops, shits itself")

      expect(post.valid?).to be true
      expect(post.errors).not_to have_key(:title)
      expect(post.title).to eq("He who poops, ***** itself")
    end

    it "uses the :vowels replacement method" do
      klass = generate_new_class.call("Post", obscenity: { sanitize: true, replacement: :vowels })
      post = klass.new(title: "He who poops, shits itself")

      expect(post.valid?).to be true
      expect(post.errors).not_to have_key(:title)
      expect(post.title).to eq("He who poops, sh*ts itself")
    end

    it "uses a custom replacement string" do
      klass = generate_new_class.call("Post", obscenity: { sanitize: true, replacement: "[censored]" })
      post = klass.new(title: "He who poops, shits itself")

      expect(post.valid?).to be true
      expect(post.errors).not_to have_key(:title)
      expect(post.title).to eq("He who poops, [censored] itself")
    end
  end
end
