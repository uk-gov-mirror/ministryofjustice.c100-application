class EmailSubmission < ApplicationRecord
  belongs_to :c100_application

  # :nocov:
  def initialize(params = {})
    @c100_application = params[:c100_application]
    @email_copy_to = @c100_application.try(:receipt_email)
    @reference_code = @c100_application.try(:reference_code)
    @to_address = @c100_application.try(:screener_answers_court).try(:email)
    @from = ENV['SUBMISSION_EMAIL_FROM'] || 'from@example.com'
    super
  end

  def send!(pdf_file_path)
    send_copy_to_court(pdf_file_path)
    send_copy_to_user(pdf_file_path) if @email_copy_to.present?

    # save the timestamp & message id
    save!
  end

  private

  def send_copy_to_court(pdf_file_path)
    # if the court case worker hits reply, it should go to either
    # the email given by the user (if present),
    # or the default submission email address
    # (in case it bounces, and the bounce-back includes the
    # submitted user data)
    response = CourtMailer.submission_to_court(
      c100_application: c100_application,
      from: @from,
      to: @to_address,
      reply_to: (@email_copy_to || @from),
      attachment: pdf_file_path
    ).deliver_now!

    self.sent_at = Time.now.utc
    self.to_address = @to_address
    self.message_id = response.message_id
  end

  def send_copy_to_user(pdf_file_path)
    # if the user hits reply, it should go to the court
    response = ReceiptMailer.copy_to_user(
      c100_application: c100_application,
      from: @from,
      to: @email_copy_to,
      reply_to: @to_address,
      attachment: pdf_file_path
    ).deliver_now!

    self.user_copy_sent_at = Time.now.utc
    self.user_copy_message_id = response.message_id
  end
  # :nocov:
end