class Rack::Attack
  # Throttle all requests by IP (2 requests/10 seconds)
  throttle('req/ip', limit: 2, period: 10.seconds) do |req|
    req.ip
  end

  # Throttle POST requests to /api/v1/login by IP address
  throttle('logins/ip', limit: 5, period: 20.minutes) do |req|
    if req.path == '/api/v1/login' && req.post?
      req.ip
    end
  end

  # Throttle POST requests to /api/v1/login by email address
  throttle("logins/email", limit: 5, period: 20.minutes) do |req|
    if req.path == '/api/v1/login' && req.post?
      # Use normalized_email as a discriminator
      req.params['email'].to_s.downcase.gsub(/\s+/, "")
    end
  end
end
