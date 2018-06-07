namespace :loyalty do
  namespace :db do
    desc 'Create the reporting database'
    task create: :environment do
      config = ActiveRecord::Base.configurations["loyalty_#{Rails.env}"]

      # Database is null because it hasn't been created yet.
      ActiveRecord::Base.establish_connection(config.merge('database' => nil))
      ActiveRecord::Base.connection.create_database(config['database'], config)
    end
  end
end