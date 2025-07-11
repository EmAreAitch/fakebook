require "test_helper"

class GenerateBotJobTest < ActiveJob::TestCase
  test "assert bot creation for bot request" do
    VCR.use_cassette("groq_api/generate_bot", record: :new_episodes) do
      bot_request = bot_requests(:one)
      assert_difference [ "Bot.count", "Profile.count" ] do
        assert_enqueued_with(job: GenerateBotJob, args: [ bot_request ]) do
            GenerateBotJob.perform_later(bot_request)
         end
        perform_enqueued_jobs
      end
      bot_request.reload
      assert_enqueued_with(job: GenerateTimelineJob, args: [ bot_request.bot ])
      assert bot_request.bot == Bot.order(:created_at).last, "Bot Request is assigned newly created bot"
      assert bot_request.bot.interests.pluck(:name).sort == bot_request.tags.sort, "Bot Request tags are new bot tags"
      assert bot_request.bot.profile_completed?, "Bot profile is completed"
    end
  end
end
