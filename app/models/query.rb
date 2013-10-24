# == Schema Information
#
# Table name: schema_migrations
#
#  version :string(255)   not null
#

class Query < ActiveRecord::Base
  set_table_name 'schema_migrations'
end
