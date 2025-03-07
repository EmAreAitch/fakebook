class InterestTagsExtractor < GroqService
  PROMPT = <<~PROMPT.freeze
    Analyze the following post content and extract interest tags in two categories: niche and general.

    # Requirements
    - Generate two sets of tags:
      1. **Niche Tags (3-5 tags):** Capture the specific subject matter or context of the post.
      2. **General Tags (7-10 tags):** Represent broad topics with universal appeal.
    - Both sets must include at least one tag that explicitly classifies the domain of the content.
    - **Do not repeat tags:** Ensure that no tag appears in both the niche and general categories.
    - Tags should be **generic, engaging, and interesting**—optimized for user curiosity and discoverability.
    - All tags must be **lemmatized** (reduced to their base form).

    # Compound Topics
    - If a compound topic exists (e.g., "ruby on rails"), include:
      - The full topic (e.g., "ruby on rails").
      - Key components if they are relevant standalone interests (e.g., "ruby").
    - Standalone components should be weighted at 90% of the compound tag's weight, rounded to the nearest multiple of 5.

    # Tag Format
    - Use **only lowercase alphanumeric characters and spaces** (no punctuation, special symbols, dashes, or underscores).
    - Prefer **single-word tags** unless two-word tags add clarity.

    # Weighting System
    - Assign a weight from **1 to 100**:
      - **Niche tags:** 85-100 (most specific and targeted).
      - **General tags:** 60-85 (broad and widely relevant).

    # Output Format
    - Return a valid JSON object:
      {
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

    Generate JSON output for this post:
  PROMPT

  def self.extract_tags_from(post_content)
    content_messages = [
      S(PROMPT),
      U(post_content)
    ]

    response = client.chat(
      content_messages,
      json: true,
      temperature: 0
    )

    JSON.parse(response["content"])
  rescue JSON::ParserError
    { "tags" => { "niche" => {}, "general" => {} } }
  end
end
