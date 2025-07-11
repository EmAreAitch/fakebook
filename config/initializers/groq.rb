# frozen_string_literal: true

Groq.configure do |config|
  config.api_key = ENV["GROQ_API_KEY"]
  config.model_id = "llama-3.3-70b-versatile"
  config.request_timeout = 90
  config.max_tokens = 32768
end
