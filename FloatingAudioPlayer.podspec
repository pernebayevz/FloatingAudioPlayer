#
# Be sure to run `pod lib lint FloatingAudioPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FloatingAudioPlayer'
  s.version          = '0.1.0'
  s.summary          = 'FloatingAudioPlayer is lightweight floating/draggable Audio Player View written in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A Swift floating/draggable audio player like in Spotify & Apple Music apps that remains on top of all screens.
                       DESC

  s.homepage         = 'https://github.com/pernebayev/FloatingAudioPlayer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pernebayevz' => 'swiftisgreat@gmail.com' }
  s.source           = { :git => 'https://github.com/pernebayevz/FloatingAudioPlayer', :tag => s.version.to_s }
  s.social_media_url = 'https://www.instagram.com/pernebayevz/'

  s.ios.deployment_target = '12.0'

  s.source_files = 'Source/**/*.swift'
  s.resource_bundles = {
    'FloatingAudioPlayer' => ['Source/**/*.{xib,xcassets}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.platform = :ios
  # s.dependency 'AFNetworking', '~> 2.3'
end
