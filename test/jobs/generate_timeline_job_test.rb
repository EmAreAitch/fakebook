require "test_helper"

class GenerateTimelineJobTest < ActiveJob::TestCase
  test "generation of post timeline" do
    VCR.use_cassette("groq_api/generate_timeline", record: :new_episodes) do
      interests = [ "RUBY", "RUBY ON RAILS", "WEB DEVELOPEMT", "BACKEND DEVELOPMENT" ].map { Interest.create(name: it) }
      bot = bots(:bot_two)
      bot.interests = interests
      bot.save
      assert_difference [ "PostTimeline.count" ] do
        assert_enqueued_with(job: GenerateTimelineJob, args: [ bot ]) do
            GenerateTimelineJob.perform_later(bot)
         end
        perform_enqueued_jobs
      end
      bot.reload
      assert bot.post_timeline.present?, "Post timeline created"
      assert_no_difference [ "PostTimeline.count" ] do
        assert_enqueued_with(job: GenerateTimelineJob, args: [ bot ]) do
            GenerateTimelineJob.perform_later(bot)
         end
        assert_changes -> { bot.reload.post_timeline.topics } do
          perform_enqueued_jobs
        end
      end
    end
  end
end
