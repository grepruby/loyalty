require 'yaml'

loyalty_db = File.join(File.dirname(__FILE__),"../loyalty_database.yml")
LOYALTY_DATABASE = YAML.load(ERB.new(File.read(loyalty_db)).result)
