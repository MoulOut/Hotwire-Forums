class AddPostsCountToDiscussions < ActiveRecord::Migration[8.0]
  def change
    add_column :discussions, :posts_count, :integer, default: 0
  end
end
