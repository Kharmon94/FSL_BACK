# Admin seed from env (skip if no password configured)
email = ENV["ADMIN_SEED_EMAIL"]&.strip
password = ENV["ADMIN_SEED_PASSWORD"]&.strip

if email.present? && password.present?
  user = User.find_or_initialize_by(email: email.downcase)
  user.password = password
  user.admin = true
  user.save!
  puts "Admin user #{email} created/updated"
else
  puts "Skipping admin seed (set ADMIN_SEED_EMAIL and ADMIN_SEED_PASSWORD)"
end
