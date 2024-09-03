namespace :users do
  desc 'Generate API tokens for users without one'
  task generate_api_tokens: :environment do
    User.where(api_token: nil).find_each do |user|
      user.update(api_token: SecureRandom.hex(20))
      puts "Generated API token for user: #{user.email}"
    end
    puts 'Finished generating API tokens.'
  end
end
