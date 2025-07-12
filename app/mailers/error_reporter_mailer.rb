class ErrorReporterMailer < ApplicationMailer
  default to:    ENV.fetch("ERROR_REPORT_EMAIL"),
          from:  "no‑reply@#{Rails.application.config.action_mailer.default_url_options[:host]}"

  def job_failed(job_class, args, exception)
    @job_class = job_class
    @args      = args
    @exception = exception
    
    mail(
      subject: "[#{Rails.env.upcase}] Job Failed: #{job_class}",
      body:    <<~BODY
        Job:       #{job_class}
        Arguments: #{@args.inspect}
        Error:     #{exception.class}: #{exception.message}
        Backtrace:
        #{exception.backtrace&.take(10).join("\n")}
      BODY
    )
  end
end
