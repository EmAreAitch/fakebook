class TopicListGenerator < GroqService
  PROMPT = <<~PROMPT.freeze
    Generate a JSON object for an AI-powered influencer's content strategy. The object should include:
    1. A tweet topic timeline: Exactly 365 unique, short and niche topics for daily tweets, tailored to the provided interests.

    Output:
    A JSON object with the format:

    json

    {
      "topics": [
        "1. topic1",
        "2. topic2",
        "3. topic3",
        ...
        "365. topic365"
      ]
    }

    Topics: Each topic must be unique, specific, and directly relevant to the interests. Ensure exactly 365 topics with no repetitions.
  PROMPT

  def self.generate_topics_for(interests)
    content_messages = [
      S(PROMPT),
      U(interests.join(", "))
    ]

    response = client.chat(
      content_messages,
      json: true
    )

    result = JSON.parse(response["content"])

    result["topics"].map! { it.from(it.index(" ") + 1) }

    result
  end
end
