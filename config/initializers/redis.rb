$redis = Redis.new

url = ENV["REDISCLOUD_URL"]
puts url
if url
  Sidekiq.configure_server do |config|
    config.redis = { url: url }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: url }
  end
  @redis = Redis.new(url: url) if url
  @redis = Redis.new(url: 'redis://127.0.0.1:6379') unless url
end