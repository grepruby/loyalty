desc "Explaining what the task does"
namespace :loyalty do
  namespace :db do
    desc 'Create the loyalty database'
    task create: :environment do
      config = ActiveRecord::Base.configurations["loyalty_#{Rails.env}"]

      # Database is null because it hasn't been created yet.
      ActiveRecord::Base.establish_connection(config.merge('database' => nil))
      ActiveRecord::Base.connection.create_database(config['database'], config)
    end

    desc 'drop the loyalty database'
    task drop: :environment do
      ActiveRecord::Base.connection.drop_database("loyalty_#{Rails.env}")
    end

    desc 'Migrates the loyalty_* database'
    task :migrate => :environment do
      with_engine_connection do
        ActiveRecord::MigrationContext.new(File.expand_path("../../../db/migrate", __FILE__)).migrate
      end
      Rake::Task['loyalty:db:schema:dump'].invoke
    end

    desc "Dumps loyalty schema"
    task :'schema:dump' => :environment do
      require 'active_record/schema_dumper'

      with_engine_connection do
        File.open(File.join(Rails.root, 'db', 'loyalty_schema.rb'), 'w') do |file|
          ActiveRecord::SchemaDumper.dump ActiveRecord::Base.connection, file
        end
      end
    end

    desc 'Loads loyality schema'
    task :'schema:load' => :environment do
      with_engine_connection do
        load File.join(Rails.root, 'db', 'loyalty_schema.rb')
      end
    end
  end
end

# Hack to temporarily connect AR::Base to your engine.
def with_engine_connection
  original = ActiveRecord::Base.remove_connection
  ActiveRecord::Base.establish_connection "loyalty_#{Rails.env}".to_sym
  yield
ensure
  ActiveRecord::Base.establish_connection original
end