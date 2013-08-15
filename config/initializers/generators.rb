Rails.application.config.generators do |g|
  g.test_framework :rspec, fixture: false, view_specs: false, helper_specs: false
end
