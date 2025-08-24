# frozen_string_literal: true

require 'rails'
require 'active_record'
require 'sqlite3'

# Setup minimal Rails application
class TestApp < Rails::Application
  config.eager_load = false
  config.secret_key_base = 'secret_key_base'
  config.logger = Logger.new($stdout)
end
Rails.application.initialize!

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :payments, force: true do |t|
    t.decimal :amount, precision: 10, scale: 0, default: 0, null: false
  end
end

class Payment < ActiveRecord::Base
end

class ChangeAmountToAddScale < ActiveRecord::Migration::Current
  def change
    reversible do |dir|
      dir.up do
        change_column :payments,
                      :amount,
                      :decimal,
                      precision: 10,
                      scale: 2,
                      default: 0,
                      null: false
      end

      dir.down do
        change_column :payments,
                      :amount,
                      :decimal,
                      precision: 10,
                      scale: 0,
                      default: 0,
                      null: false
      end
    end
  end
end

describe 'ActiveRecord migration' do
  it 'changes table column scale from 0 to 2' do
    ChangeAmountToAddScale.migrate(:up)
    Payment.reset_column_information
    expect(Payment.columns.find { |c| c.name == 'amount' }.sql_type)
      .to eq('decimal(10,2)')
  end

  it 'reverts table column scale from 2 to 0' do
    ChangeAmountToAddScale.migrate(:down)
    Payment.reset_column_information
    expect(Payment.columns.find { |c| c.name == 'amount' }.sql_type)
      .to eq('decimal(10,0)')
  end
end
