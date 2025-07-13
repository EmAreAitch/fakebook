class PostGenerator < GroqService
  PROMPT = <<~PROMPT.freeze
    Generate a JSON object for a topic-based post. The object should include:
    1. content: A detailed, up-to-date post strictly adhering to the provided topic. The post should:
       - Begin with the topic title.
       - Include clear and structured points or numbered lists.
       - Be engaging and easy to read.
       - Code blocks should be fenced
       - Only include a conclusion section if it is absolutely necessary for clarity or summarization. If the content is already clear and complete, do not append a conclusion.
       - Reflect current information without referencing outdated events.
    2. images: Optional image prompts that visually complement the post content. Decide whether to include images based on the nature of the content:
       - If the topic naturally benefits from visual representation (e.g., art, locations, step-by-step guides), include 1 or 2 extremely detailed image prompts.
       - If visual context does not add significant value, leave the images field as an empty array.
       - **Important:** These image prompts will be used by another generative AI to produce images. Therefore, the descriptions must be extremely detailed—vividly describing the scene, colors, composition, and style—while being mindful of AI limitations. In particular, avoid including excessive text within the image prompt since generating text in images can be challenging.
    3. tags: Mandatory interest-based tags generated in two categories:
       a. **Niche Tags (3-5 tags):** Capture the specific subject matter or context of the post.
          - Must include at least one tag that explicitly classifies the niche domain of the content.
          - The domain classification tag should be as broad as possible, directly tied to the content, and unambiguous.
          - Avoid overly technical or narrow terms.
       b. **General Tags (7-10 tags):** Represent broad topics with universal appeal and indicate the overall domain of the content.
          - Must include at least one tag that explicitly classifies the general domain of the content.
          - The domain classification tag should be as broad as possible, directly tied to the content, and unambiguous.
       - **Do not repeat tags:** Ensure that no tag appears in both the niche and general categories.
       - Tags should be generic, engaging, and interesting—optimized for user curiosity and discoverability.
       - All tags must be lemmatized (reduced to their base form).
       - **Directness Requirement:** Every tag must be 100% directly related to the post content with zero ambiguity.
       - If a compound topic exists (e.g., "ruby on rails"), include:
         - The full compound topic.
         - Key components if they are relevant as standalone interests (e.g., "ruby").
         - Standalone components should be weighted at 90% of the compound tag's weight, rounded to the nearest multiple of 5.
       - Use only lowercase alphanumeric characters and spaces (no punctuation, special symbols, dashes, or underscores).

    # Weighting System for Tags
    - Each tag must be assigned a weight from 1 to 100.
      - **Niche tags:** Weights should fall between 85 and 100 (most specific and targeted).
      - **General tags:** Weights should fall between 60 and 85 (broad and widely relevant).

    Output:
    A JSON object with the format:

    {
      "content": "Topic Title

      A detailed post about the topic using bullet points or numbers. [Include a conclusion section only if absolutely necessary]",
      "images": [
        "Extremely detailed image prompt 1",
        "Extremely detailed image prompt 2"
      ],
      "tags": {
        "niche": {
          "tag1": weight1,
          "tag2": weight2,
          ...
        },
        "general": {
          "tag1": weight1,
          "tag2": weight2,
          ...
        }
      }
    }

    Guidelines:
    - Ensure the content is detailed, up-to-date, structured, and closely related to the topic.
    - For the images field, use logical reasoning to decide whether to include images:
         - If the topic naturally lends itself to visual illustration or benefits from visual context, include 1 or 2 extremely detailed image prompts.
         - Otherwise, leave the images field as an empty array.
    - **Important:** The image prompts will be used by another generative AI to create images, so the descriptions must be crafted with its limitations in mind (e.g., difficulty in rendering excessive text).
    - Only include a conclusion in the post content if it is absolutely necessary for clarity or summarization.
    - Do not include personal opinions or time-specific elements.
  PROMPT

  def self.generate_post_for(topic)
    content_messages = [
      S(PROMPT),
      U(topic)
    ]

    response = client.chat(
      content_messages,
      json: true,
      temperature: 0
    )

    JSON.parse(response["content"]).tap do
      it["tags"] = it["tags"].values.reduce(&:merge).transform_keys(&:upcase)
      it["images"].map! do |img|
        PollinationsService.generate_image(img).then do |gen_img|
          { io: gen_img, filename: SecureRandom.hex(10), content_type: gen_img.content_type }
        end
      end
    end
  rescue JSON::ParserError
    { "content" => "Failed to generate content.", "images" => [] }
  end
end
