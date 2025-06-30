# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "lib/omniauth/wix/version"

Gem::Specification.new do |spec|
  spec.name = "omniauth-wix"
  spec.version = Omniauth::Wix::VERSION
  spec.authors = ["Alishba Atther"]
  spec.email = ["alishbaather321@gmail.com"]

  spec.summary = "Omniauth Stategy for WIX"
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'omniauth-oauth2'
  spec.add_runtime_dependency 'rest-client'
end