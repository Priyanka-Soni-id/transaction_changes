
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "transaction_changes/version"

Gem::Specification.new do |spec|
  spec.name          = "transaction_changes"
  spec.version       = TransactionChanges::VERSION
  spec.authors       = ["Priyanka"]
  spec.email         = ["priyankatrancedi.iitd@gmail.com"]

  spec.summary       = "Store attribute changes during ActiveRecord Transaction"
  spec.description   = "Store attribute changes during ActiveRecord Transaction"
  spec.homepage      = "https://github.com/Priyanka-Soni-id/transaction_changes"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "activesupport"
  spec.add_dependency "activerecord"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "byebug"

end
