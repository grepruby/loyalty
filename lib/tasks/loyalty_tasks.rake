# Loyalty engine specific rake tasks
class LoyaltyDatabase
  MIGRATION_FILES_PATH = '../../db/migrate'.freeze
  SCHEMA_FILE = 'loyalty_schema.rb'.freeze

  class << self
    def create
      config = LOYALTY_DATABASE[Rails.env]

      # Database is null because it hasn't been created yet.
      ActiveRecord::Base.establish_connection(config.merge('database' => nil))
      ActiveRecord::Base.connection.create_database(config['database'], config)
    end

    def drop
      ActiveRecord::Base.connection
                        .drop_database(LOYALTY_DATABASE[Rails.env]['database'])
    end

    def migrate
      with_engine_connection do
        ActiveRecord::MigrationContext
          .new(File.expand_path(MIGRATION_FILES_PATH, __dir__))
          .migrate
      end
      schema_dump
    end

    def rollback
      with_engine_connection do
        ActiveRecord::MigrationContext
          .new(File.expand_path(MIGRATION_FILES_PATH, __dir__))
          .rollback
      end
      schema_dump
    end

    def schema_dump
      with_engine_connection do
        File.open(File.join(Rails.root, 'db', SCHEMA_FILE), 'w') do |file|
          ActiveRecord::SchemaDumper.dump ActiveRecord::Base.connection, file
        end
      end
    end

    def schema_load
      with_engine_connection do
        load File.join(Rails.root, 'db', SCHEMA_FILE)
      end
    end

    private

    def with_engine_connection
      original = ActiveRecord::Base.remove_connection
      ActiveRecord::Base.establish_connection LOYALTY_DATABASE[Rails.env]
      yield
    ensure
      ActiveRecord::Base.establish_connection original
    end
  end
end

desc 'Explaining what the task does'
namespace :loyalty do
  namespace :db do
    desc 'Create the loyalty database'
    task create: :environment do
      LoyaltyDatabase.create
    end

    desc 'drop the loyalty database'
    task drop: :environment do
      LoyaltyDatabase.drop
    end

    desc 'Migrates the loyalty_* database'
    task migrate: :environment do
      LoyaltyDatabase.migrate
    end

    desc 'Rollback the loyalty_* database'
    task rollback: :environment do
      LoyaltyDatabase.rollback
    end

    desc 'Loads loyality schema'
    task :'schema:load' => :environment do
      LoyaltyDatabase.schema_load
    end
  end
end
