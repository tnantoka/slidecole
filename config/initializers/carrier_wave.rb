CarrierWave.configure do |config|
  config.root = Rails.root
end
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
