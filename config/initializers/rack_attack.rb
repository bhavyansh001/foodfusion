class Rack::Attack
  # Throttle all requests by IP (2 requests/10 seconds)
  throttle('req/ip', limit: 20, period: 10.seconds) do |req|
    req.ip
  end

  # Throttle all requests to /api/ endpoints by IP
  throttle('api/ip', limit: 60, period: 1.minute) do |req|
    req.ip if req.path.start_with?('/api/')
  end

  # Throttle POST requests to /api/v1/login by IP address
  throttle('logins/ip', limit: 5, period: 5.minutes) do |req|
    req.ip if req.path == '/api/v1/login' && req.post?
  end

  # Throttle POST requests to /api/v1/login by email address
  throttle('logins/email', limit: 5, period: 5.minutes) do |req|
    if req.path == '/api/v1/login' && req.post?
      # Use normalized_email as a discriminator
      req.params['email'].to_s.downcase.gsub(/\s+/, '')
    end
  end

  # Block requests from a specific IP (for example, known malicious IP)
  blocklist('block 1.2.3.4') do |req|
    '1.2.3.4' == req.ip
  end
end
