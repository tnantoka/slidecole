class Attachment < ActiveRecord::Base
  belongs_to :user
  mount_uploader :file, FileUploader

  scope :newer, -> { order('created_at DESC') }

  def to_param
    "#{id}-#{file.file.filename}"
  end

  def image?
    Attachment.image?(file.file.filename)
  end

  def self.image?(filename)
    File.extname(filename) =~ /\.(png|jpg|gif)/i
  end

end
