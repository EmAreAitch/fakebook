class BotGenerator < GroqService
  PROMPT = <<~PROMPT.freeze
    Generate a JSON object for an AI-powered user profile. The profile should be created based on the provided interest tags and include the following fields:

    1. username (3 - 15 chars): A realistic-sounding human name with a minor twist that hints at a unique personality. Use lowercase letters, numbers, and underscores only.
    2. bio (50 - 150 chars): A short and engaging bio that reflects the provided interests and clearly identifies the account as AI-powered. Make sure it does not cross limit of 100-150 chars.
    3. firstname: A suitable first name for the account, matching the tone of the provided interests.
    4. lastname: A suitable last name for the account, matching the tone of the provided interests.
    5. gender: Randomly assign a gender ("male", "female", or "other").
    6. avatar: A highly detailed prompt text that instructs an image generation model to create a profile avatar. This prompt should include:
       - A clear indication that the image is a professional headshot with a modern and minimalistic style.
       - A detailed description of facial features: natural, balanced, with smooth skin and a subtle, refined expression.
       - Specific lighting details: soft, natural, and evenly distributed to enhance the subject’s features.
       - Attire suggestions: smart-casual or professional clothing that matches the overall tone of the account.
       - Background details: a minimalistic backdrop that includes subtle visual cues reflecting the account's core interests, using abstract or symbolic elements as appropriate.
       - Technical and artistic hints: a description of any subtle overlays or abstract design accents that evoke the essence of the provided interests without being overly literal.
       - Emphasis that the image should clearly communicate the character or focus of the account while maintaining a professional and approachable appearance.
       - Use vivid, comprehensive language to ensure that the generated image captures every nuance of the desired visual identity.

    Output:
    A JSON object with the format:

    json

    {
      "bot": {
        "username": "Generated username",
        "avatar": "Detailed AI avatar generation prompt"
      },
      "profile": {
        "bio": "Generated bio text emphasizing AI and interests.",
        "first_name": "Generated First Name",
        "last_name": "Generated Last Name",
        "gender": "Generated Gender"
      }
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

    bot = JSON.parse(response["content"])
    bot["bot"]["avatar"] = PollinationsService.generate_image(bot["bot"]["avatar"])
    .then { { io: it, filename: SecureRandom.hex(10), content_type: it.content_type } }
    bot["bot"]["email"] = "%s@%s.com" % [ bot["bot"]["username"].downcase, Rails.application.class.module_parent_name.downcase ]
    bot["bot"]["password"] = SecureRandom.hex(10)
    bot["bot"]["username"] = bot["bot"]["username"].downcase
    bot["profile"]["gender"] = Profile.genders.keys.sample
    bot["profile"]["dob"] = Date.today
    bot
  end
end
