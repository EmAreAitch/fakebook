class GroqService
  class << self
    include Groq::Helpers
  end

  def self.client
    @client ||= Groq::Client.new
  end
end
