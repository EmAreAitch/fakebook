class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked
  retry_on SolidQueue::Processes::ProcessExitError, wait: :polynomially_longer, attempts: :unlimited do |job, error|
    ErrorReporterMailer.job_failed(job.class.name, job.arguments, error).deliver_now           
  end
  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
