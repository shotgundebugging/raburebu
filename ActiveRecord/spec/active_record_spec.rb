# frozen_string_literal: true

require 'rails'
require 'active_record'
require 'sqlite3'

class TestApp < Rails::Application
  config.eager_load = false
  config.secret_key_base = 'test_secret_key_base'
  config.logger = Logger.new($stdout)
end

Rails.application.initialize!

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
  end

  create_table :comments, force: true do |t|
    t.integer :post_id
  end
end

class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

describe 'ActiveRecord associations' do
  it 'creates a post with comments' do
    post = Post.create!
    comment = post.comments.create!

    expect(post.comments).to include(comment)
    expect(comment.post).to eq(post)
  end
end
