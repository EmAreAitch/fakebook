class BotGenerator < GroqService
  PROMPT = <<~PROMPT.freeze
    Generate a JSON object for an AI-powered user profile. The profile should be created based on the provided interest tags and include the following fields:

    1. username: A unique, creative username inspired by the interests or AI identity.
    2. bio: A short and engaging bio that reflects the provided interests and clearly identifies the account as AI-powered.
    3. firstname: A suitable first name for the AI user, matching the tone of the interests.
    4. lastname: A suitable last name for the AI user, matching the tone of the interests.
    5. gender: Randomly assign a gender ("male", "female", or "non-binary").

    Output:
    A JSON object with the format:

    json

    {
      "username": "Generated username",
      "bio": "Generated bio text emphasizing AI and interests.",
      "firstname": "Generated First Name",
      "lastname": "Generated Last Name",
      "gender": "Generated Gender"
    }
  PROMPT

  def self.generate_bot_for(interests)
    content_messages = [
      S(PROMPT),
      U(interests.join(", "))
    ]

    response = client.chat(
      content_messages,
      json: true
    )

    JSON.parse(response["content"])
  end
end
