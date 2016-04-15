#
#  Podfile
#
#  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
#

# Pod sources
require './scripts/inbbbox_keys.rb'
require './scripts/acknowledgements.rb'
source 'https://github.com/CocoaPods/Specs.git'

# Initial configuration
platform :ios, '8.2'
inhibit_all_warnings!
use_frameworks!

xcodeproj 'Inbbbox', 'Development' => :debug, 'Production' => :release, 'Staging' => :release, 'Test' => :debug, 'Release' => :release

plugin 'cocoapods-keys', {
  :project => 'Inbbbox',
  :keys => InbbboxKeys.new.all_keys
}

pod 'AsyncSwift', '~> 1.6'
pod 'KeychainAccess', '~> 2.3'
pod 'PromiseKit', '~> 3.1'
pod 'SwiftyJSON', '~> 2.3'
pod 'HockeySDK', '~> 3.8'
pod 'PureLayout', '~> 3.0'
pod 'SwiftyUserDefaults', '~> 2.0'
pod 'GPUImage', '~> 0.1'
#fork cause of https://github.com/icanzilb/EasyAnimation/issues/25
pod 'EasyAnimation', :git => 'https://git@github.com/PatrykKaczmarek/EasyAnimation.git', :commit => '3e97dc7e2f262222e2fd614ff5143d6432f73a7d'
pod 'Gifu', '~> 1.0'
pod 'ZFDragableModalTransition', '~> 0.6'
#fork cause of https://github.com/Haneke/HanekeSwift/pull/307
pod 'HanekeSwift', :git => 'https://github.com/pikor/HanekeSwift.git'
pod 'DZNEmptyDataSet', '~> 1.7'
pod 'GoogleAnalytics', '~> 3.14'
pod 'TTTAttributedLabel', '~> 1.13'
target 'Tests' do link_with 'Unit Tests'
  pod 'Quick', '~> 0.8', :configurations => ['Test']
  pod 'Nimble', '~> 3.1', :configurations => ['Test']
  pod 'Dobby', '~> 0.5', :configurations => ['Test']
  pod 'Mockingjay', '~> 1.1', :configurations => ['Test']
end

post_install do |installer|

  Acknowledgements.new.generate_html_acknowlegements('Inbbbox/Resources/Acknowledgements.html')

  puts 'Setting appropriate code signing identities'
  installer.pods_project.targets.each { |target|
    {
      'iPhone Developer' => ['Debug', 'Development', 'Test'],
      'iPhone Distribution' => ['Release', 'Staging', 'Production'],
      }.each { |value, configs|
        target.set_build_setting('CODE_SIGN_IDENTITY[sdk=iphoneos*]', value, configs)
      }
    }

  end

  class Xcodeproj::Project::Object::PBXNativeTarget

    def set_build_setting setting, value, config = nil
      unless config.nil?
        if config.kind_of?(Xcodeproj::Project::Object::XCBuildConfiguration)
          config.build_settings[setting] = value
        elsif config.kind_of?(String)
          build_configurations
          .select { |config_obj| config_obj.name == config }
          .each { |config| set_build_setting(setting, value, config) }
        elsif config.kind_of?(Array)
          config.each { |config| set_build_setting(setting, value, config) }
        else
          raise 'Unsupported configuration type: ' + config.class.inspect
        end
      else
        set_build_setting(setting, value, build_configurations)
      end
    end
  end
