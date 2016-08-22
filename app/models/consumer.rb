class Consumer < ActiveRecord::Base
  attr_encrypted :lti_secret, key: 'this-is-just-a-test-encryption-key-it-is-not-very-secure'
  after_initialize :ensure_lti_credentials

  private

  def ensure_lti_credentials
    self.lti_key ||= SecureRandom.uuid
    self.lti_secret ||= SecureRandom.urlsafe_base64(35)
  end
end
