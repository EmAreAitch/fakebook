namespace :active_storage do
  desc "Purges unattached Active Storage blobs. Run regularly."
  task purge_unattached: :environment do
    ActiveStorage::Blob.unattached.find_each(&:purge_later)
    puts "Purge Completed."
  end
end
