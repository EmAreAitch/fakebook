# frozen_string_literal: true

Groq.configure do |config|
  config.api_key = ENV["GROQ_API_KEY"]
  config.model_id = "deepseek-r1-distill-llama-70b"
  config.request_timeout = 60
  config.max_tokens = 32768
end
