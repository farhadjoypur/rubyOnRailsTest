class User < ApplicationRecord
validates :FIRST_NAME, presence: true
  validates :LAST_NAME, presence: true
  validates :EMAIL_ID, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
mount_uploader :user_file, UserFileUploader
end
