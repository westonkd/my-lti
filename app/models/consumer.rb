class Consumer < ActiveRecord::Base
  after_initialize :ensure_lti_credentials

  private

  def ensure_lti_credentials
    self.lti_key ||= SecureRandom.uuid
    self.lti_secret ||= SecureRandom.urlsafe_base64(35)
    self.save!
  end
end
