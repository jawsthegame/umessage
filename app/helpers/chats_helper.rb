module ChatsHelper
  CONTACTS = Contacts.new

  def attachment_image_tag(attachment, **opts)
    path = attachment.filename.gsub(/.+Attachments\//, "") rescue nil

    if path
      path = "/images/message_attachments/#{path}"
      image_tag(asset_path(path, skip_pipeline: true), **opts)
    end
  end

  def datetime(datetime)
    format = datetime.today? ? :conversations_today : :conversations_longer
    l(datetime, format: format)
  end
end
