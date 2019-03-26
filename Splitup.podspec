#
# Be sure to run `pod lib lint Splitup.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Splitup'
  s.version          = '0.1.12'
  s.summary          = 'Splitup serves to add vertical split view controllers to the iOS application'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Splitup is Swift library which serves to add vertical split view controllers to the iOS application.
                       DESC

  s.homepage         = 'https://github.com/BozhkoAlexander/Splitup'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BozhkoAlexander' => 'alexander.bozhko@filmgrail.com' }
  s.source           = { :git => 'https://github.com/BozhkoAlexander/Splitup.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'Splitup/Classes/**/*'
  #s.resources = ['Splitup/Assets/*']
  
  # s.resource_bundles = {
  #   'Splitup' => ['Splitup/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
