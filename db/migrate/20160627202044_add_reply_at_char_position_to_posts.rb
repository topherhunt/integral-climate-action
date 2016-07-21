class AddReplyAtCharPositionToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :parent_id, :integer
    add_column :posts, :reply_at_char_position, :integer
    add_index :posts, :author_id
    add_index :posts, :parent_id
  end
end
