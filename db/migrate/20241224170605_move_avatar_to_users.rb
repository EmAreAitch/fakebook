class MoveAvatarToUsers < ActiveRecord::Migration[8.0]
  def up
    Profile.find_each do |profile|
      if profile.avatar.attached?
        profile.user.avatar.attach(profile.avatar.blob)
        profile.avatar.purge
      end
    end
  end

  def down
    User.find_each do |user|
      if user.avatar.attached?
        user.profile.avatar.attach(user.avatar.blob)
        user.avatar.purge
      end
    end
  end
end