# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_festival_filter_session',
  :secret      => '0aabf9ab4d427f15f9ddaf211673226c5654b38068a00dd9724fbcb4b7416da69a99cb95abd6f0ea9ccc282dda41a7d74eb6e348c6d975d7f4487117c612b5b2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
