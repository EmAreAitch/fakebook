# Rails.application.config.after_initialize do
#   [
#     ActiveStorage::DiskController,
#     ActiveStorage::Representations::RedirectController
#   ].each do |controller|    
#     controller.logger = ActiveSupport::Logger.new(nil)
#   end
# end