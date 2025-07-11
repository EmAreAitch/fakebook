require "test_helper"

class GeneratePostJobTest < ActiveJob::TestCase
  test "test post generation" do
    VCR.use_cassette("groq_api/generate_post", record: :new_episodes) do
      post_timeline = post_timelines(:one)
      bot = post_timeline.bot
      assert_difference "Post.count", 2 do
        assert_enqueued_with(job: GeneratePostJob, args: [ post_timeline.id ]) do
          GeneratePostJob.perform_later(post_timeline.id)
        end
        assert_enqueued_with(job: GeneratePostJob, args: [ post_timeline.id ], at: ->(x) { ((1.day.from_now - 5.minutes)..1.day.from_now).cover?(x) }) do
          perform_enqueued_jobs
        end
        assert_enqueued_with(job: GenerateTimelineJob, args: [ bot ]) do
          perform_enqueued_jobs
        end
      end

      assert_difference "post_timeline.counter", -2 do
        post_timeline.reload
      end
      post = Post.order(:created_at).last
      assert post.user == bot, "New post belongs to new bot"
      assert post.interests.exists?, "New post has interests tags"
    end
  end
end
