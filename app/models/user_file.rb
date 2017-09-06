class UserFile < ActiveRecord::Base
  # These user files can belong to travel_requests
  has_many :travel_files
  has_many :travel_requests, as: :filable
  has_many :grant_funded_travel_requests, as: :filable
  belongs_to :user

  # paperclip file field
  has_attached_file :uploaded_file,
    path:  ":rails_root/public/system/:attachment/:id/:style/:filename",
    url:  "/system/:attachment/:id/:style/:filename"

  CONTENT_TYPES = [
    "text/csv",
    "text/plain",
    "application/pdf",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "image/jpg",
    "image/jpeg",
    "image/png",
    "image/gif"
  ]

  validates_attachment_content_type :uploaded_file, content_type: CONTENT_TYPES
  validates_attachment_size :uploaded_file, less_than: 10.megabytes
  validates_attachment_presence :uploaded_file

  def uploaded_file_path
    uploaded_file.path if uploaded_file.present?
  end
end
