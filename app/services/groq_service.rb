class GroqService
  class << self
    include Groq::Helpers
  end

  def self.client
    @client ||= Groq::Client.new do |faraday|
      faraday.request :retry,
        methods: %i[get post],        
        retry_statuses: [ 429, 500, 502, 503, 504, 400 ],
        exceptions: Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS + [Faraday::BadRequestError, Faraday::TooManyRequestsError]      
    end
  end
end
