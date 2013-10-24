# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.2' unless defined? RAILS_GEM_VERSION
#RAILS_GEM_VERSION = '3.0.9' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  # config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_phocm_session',
    :secret      => '45cf49efac16e75b8f1bb470fad58e'
    
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  # dont want unix/ansi-escape style logging
  config.active_record.colorize_logging = false
  config.active_record.timestamped_migrations = false  
  
end
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:local]='%d-%b-%Y'  
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:local]='%d-%b-%Y'  
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:local_time]='%d %b %Y %H:%M'  

# Only save the attributes that have changed since the record was loaded.
# ActiveRecord::Base.partial_updates = true 

require 'active_record/base_ext.rb'
require 'active_record/base_without_table.rb'
require 'active_record/SQLServerAdapter_ext.rb'
require 'action_view/instance_tag_ext.rb'
require 'sql_server/column_ext.rb'
require 'array/in_groups_by.rb'
require 'string/ext.rb'

class Date
  def self.DateParseYyyyMmDd(s)
    # Return a Date, Given a string formatted as YYYY[-/]MM[-/]DD
    d=Date.new;
    if ( s.length == 4) # Assume just year (Set to July, 1st the midle of the year)
      d=Date.new(s[0,4].to_i,7,1)
    elsif (( s[2,1] == "/") || ( s[2,1] == "-"))  # Assume dd/mm/yyyy
      d=Date.new(s[6,4].to_i,s[3,2].to_i,s[0,2].to_i)
    elsif (( s[4,1] == "/") || ( s[4,1] == "-"))  # Assume yyyy-mm-dd
      d=Date.new(s[0,4].to_i,s[5,2].to_i,s[8,2].to_i)
    else  # Assume yyyymmdd
      d=Date.new(s[0,4].to_i,s[4,2].to_i,s[6,2].to_i)
    end
    d
  end
end  

