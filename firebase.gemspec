lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'firebase/version'

Gem::Specification.new do |s|
  s.name = "firebase"
  s.version = Firebase::VERSION

  s.require_paths = ["lib"]
  s.authors = ["Oscar Del Ben", "Vincent Woo"]
  s.date = "2018-01-28"
  s.description = "Firebase wrapper for Ruby"
  s.email = "info@oscardelben.com"
  s.extra_rdoc_files = [
    "CHANGELOG.md",
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "lib/firebase.rb",
    "lib/firebase/response.rb",
    "lib/firebase/server_value.rb",
    "lib/firebase/version.rb"
  ]
  s.homepage = "https://github.com/oscardelben/firebase-ruby"
  s.licenses = ["MIT"]
  s.summary = "Firebase wrapper for Ruby"

  s.add_runtime_dependency 'httpclient', '>= 2.8.3'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'googleauth'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec'
end

