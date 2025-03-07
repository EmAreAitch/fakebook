class AddCheckConstraintToFollows < ActiveRecord::Migration[8.0]
  def change
    add_check_constraint :follows, "follower_id != followed_id", name: "not_self_follow"
  end
end
