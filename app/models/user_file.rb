class UserFile < ActiveRecord::Base
  belongs_to :fileable, polymorphic: true, optional: true
  delegate :user, to: :fileable

  # paperclip file field
  has_attached_file :uploaded_file,
    path:  ":rails_root/public/system/:attachment/:id/:style/:normalize_filename",
    url:  "/system/:attachment/:id/:style/:normalize_filename"

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

  Paperclip.interpolates :normalize_filename do |attachment, style|
    attachment.instance.normalize_filename
  end

  def normalize_filename
    "#{user.lnfi}_#{fileable.return_date.strftime('%Y%m%d')}_#{fileable.id}_#{document_type}"
  end

  def uploaded_file_path
    uploaded_file.path if uploaded_file.present?
  end
end
