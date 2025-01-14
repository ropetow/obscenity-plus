Gem::Specification.new do |s|
  s.name          = "obscenity-plus"
  s.version       = "1.0.3"
  s.summary       = "An updated profanity filter in Jan 2025. Forked from the Obscenity gem."
  s.description   = "Obscenity is a profanity filter gem for Ruby, Rails (through ActiveModel), and Rack middleware."
  s.authors       = ["Ropetow"]
  s.email         = "ropetow@outlook.com"
  s.homepage      = "http://github.com/ropetow/obscenity-plus"
  s.license       = "MIT"
  s.required_ruby_version = ">= 2.7"

  s.files = Dir["{lib,config}/**/*", "README.md", "LICENSE.txt", "test/**/*"]
  s.require_paths = ["lib"]

  # Development dependencies
  s.add_development_dependency "bundler", "~> 2.0"
  s.add_development_dependency "rspec", "~> 3.12"
  s.add_development_dependency "rake", "~> 12.3"
  s.add_development_dependency "factory_bot", "~> 6.5"

  # Runtime dependencies
  s.add_runtime_dependency "rack", "~> 3.0"
  s.add_runtime_dependency "activemodel", "~> 8.0"


end


