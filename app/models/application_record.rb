class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def redis
    @redis ||= ActionCable.server.pubsub.send(:redis_connection)
  end
end
