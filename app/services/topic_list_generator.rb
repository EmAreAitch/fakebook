class TopicListGenerator < GroqService
  PROMPT = <<~PROMPT.freeze
    Generate a JSON object for an influencer's content strategy. The object should include a tweet topic timeline comprising exactly 365 daily tweet topics. Each topic must be:

    - Unique with no repetitions.
    - Brief (ideally under 100 characters).
    - Specifically tailored to the provided interests.
    - Niche and innovative, avoiding generic ideas.

    Requirements:
    1. Create 365 topics formatted as numbered strings (e.g., "1. topic1", "2. topic2", etc.).
    2. Each topic should be clear, concise, and directly reflect the given interests.
    3. Do not include any additional keys or explanatory text in the JSON output.
    4. Ensure the output is a valid JSON object with the following structure:

    {
      "topics": [
        "1. topic1",
        "2. topic2",
        "3. topic3",
        ...
        "365. topic365"
      ]
    }

    Tailor each topic to inspire engaging, daily tweets that resonate with the niche audience.
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

    result["topics"].map! { |it| it.from(it.index(" ") + 1) }

    result["topics"]
  end
end
