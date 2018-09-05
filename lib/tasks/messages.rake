namespace :messages do
  task :setup do
    `mkdir public/images`
    `ln -s ~/Library/Messages/Attachments public/images/message_attachments`
  end
end
