#
# Be sure to run `pod lib lint ScrollStack.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ScrollStack'
  s.version          = '0.1.8'
  s.summary          = 'A vertical & horizontal scrollable stack layout that supports weighted sizing of elements.'

  s.description      = <<-DESC
ScrollStack is a vertical & horizontal scrollable stack layout that supports weighted sizing of elements.
                       DESC

  s.homepage         = 'https://github.com/cmc5788/ScrollStack'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cmc5788' => 'cmc5788@gmail.com' }
  s.source           = { :git => 'https://github.com/cmc5788/ScrollStack.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.2'

  s.source_files = 'ScrollStack/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ScrollStack' => ['ScrollStack/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
