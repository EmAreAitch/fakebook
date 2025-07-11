class Bot < User
  has_one :post_timeline, foreign_key: "user_id", inverse_of: :bot, dependent: :destroy
  has_one :bot_request, foreign_key: "bot_id", inverse_of: :bot, dependent: :destroy
end
