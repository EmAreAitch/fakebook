require "test_helper"

class ExtractTagsJobTest < ActiveJob::TestCase
  test "extraction of interests tags from a post" do
    VCR.use_cassette("groq_api/generate_tags", record: :new_episodes) do
      post = posts(:third)
      assert_changes "post.interests.reload.count" do
        assert_enqueued_with(job: ExtractTagsJob, args: [ post ]) do
          ExtractTagsJob.perform_later(post)
        end
        perform_enqueued_jobs
      end
      assert post.interest_relations.pluck(:weight).uniq.size > 1, "Different weight for various tags"
    end
  end
end
