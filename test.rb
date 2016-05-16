require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: 'template1')

class User < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
  store_accessor :data, :user_id

  belongs_to :user
end

ActiveRecord::Base.transaction do
  ActiveRecord::Base.connection.create_table :users

  ActiveRecord::Base.connection.create_table :comments do |t|
    t.json :data
  end

  user = User.create!

  comment = Comment.new
  comment.user_id = user.id
  comment.save!

  p "Attribute gets set: #{comment.user_id == user.id}" # => true
  p "Can use belongs_to relation: #{comment.user == user}" # => false
  p "Can use belongs_to relation after reload: #{comment.reload.user == user}" # => false

  raise ActiveRecord::Rollback
end
