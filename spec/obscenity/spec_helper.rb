#spec_helper.rb
require 'rubygems'
require 'bundler/setup'
require 'rspec'

# Load ActiveModel and Obscenity
require 'active_model'
require 'obscenity'
require 'obscenity/active_model'

# Dummy Model for Testing
FactoryBot.define do
  factory :base_model, class: Dummy::BaseModel do
    title { "Sample title" }
  end
end

# Configure RSpec
RSpec.configure do |config|
  # Use the documentation format for test output
  config.default_formatter = 'doc' if config.files_to_run.one?

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
