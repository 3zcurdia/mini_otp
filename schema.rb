# migration.rb
require 'sequel'

DB = Sequel.sqlite('otps.db')

DB.create_table :otps do
  primary_key :id
  String :uuid
  String :phone, null: false
  String :code, null: false
  String :status, default: 'sent'
  DateTime :expired_at
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
  DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

  index [:phone, :code], unique: true
end
