require 'dotenv'
require 'osx_keychain'
Dotenv.load

class InbbboxKeys

  def initialize
    @keychain = OSXKeychain.new
  end

  REQUIRED_KEYS = [
    'ClientID',
    'ClientSecret',
    'ClientAccessToken'
  ].freeze

  OPTIONAL_KEYS = [
    'ProductionGATrackingId',
    'StagingGATrackingId',
    'HockeySDKProduction',
    'HockeySDKStaging'
  ].freeze

  def all_keys
    keys = REQUIRED_KEYS
    OPTIONAL_KEYS.each do |key|
      keys << key unless has_defined_key(key)
    end
    keys
  end

  private

  def has_defined_key(key)
    @keychain["cocoapods-keys-#{key}"].nil? && ENV[key].nil?
  end
end
