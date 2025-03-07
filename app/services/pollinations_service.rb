class PollinationsService
  APIURL = "https://image.pollinations.ai/prompt/%s?%s"

  def self.generate_image(prompt, **query)
    query = { nologo: true, enhance: true }.merge(query).to_query
    URI.open(APIURL % [ URI.encode_uri_component(prompt), query ])
  end
end
