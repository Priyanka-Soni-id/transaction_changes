require "bundler/setup"
require "transaction_changes"
require 'active_record'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ENV["RAILS_ENV"] = "test"
require 'pathname'
require 'yaml'

test_dir = Pathname.new(File.dirname(__FILE__))
config_filename = test_dir.join("database.yml").exist? ? "database.yml" : "database.yml.default"
database_yml = YAML.load(test_dir.join(config_filename).read)
ActiveRecord::Base.establish_connection database_yml['test']

ActiveRecord::Base.connection.tap do |db|
  db.drop_table(:users) if db.table_exists?(:users)
  db.create_table(:users) do |t|
    t.string :name
    t.string :occupation
    t.timestamps null: false
  end
end

Dir[test_dir.join("models/*.rb")].each{ |file| require file }

