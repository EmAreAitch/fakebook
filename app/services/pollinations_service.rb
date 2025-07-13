class PollinationsService
  APIURL = "https://image.pollinations.ai/prompt/%s?%s"  
  RETRY_DELAY = 2 # seconds

  def self.generate_image(prompt, **query)
    query = { nologo: true, referrer: "interesting.onrender.com", token: ENV["POLLINATION_TOKEN"] }.merge(query).to_query
    url = APIURL % [URI.encode_www_form_component(prompt), query]

    retries = 0
    begin
      URI.open(url)
    rescue OpenURI::HTTPError => e
      status_code = e.io.status[0]
      retry_delay = e.io.meta["retry-after"].to_i
      if (["429"] + (500..599).map(&:to_s)).include?(status_code)
        retries += 1
        puts "Retrying with %d delay" % (retry_delay || RETRY_DELAY)
        sleep(retry_delay || RETRY_DELAY)        
        retry
      else        
        raise
      end
    end
  end
end
