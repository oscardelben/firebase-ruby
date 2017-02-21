Gem::Specification.new do |s|
  s.name = "firebase"
  s.version = "0.2.6"

  s.require_paths = ["lib"]
  s.authors = ["Oscar Del Ben"]
  s.date = "2015-11-26"
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
    "lib/firebase/server_value.rb"
  ]
  s.homepage = "http://github.com/oscardelben/firebase-ruby"
  s.licenses = ["MIT"]
  s.summary = "Firebase wrapper for Ruby"

  s.add_runtime_dependency 'httpclient'
  s.add_runtime_dependency 'json'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec'
end

