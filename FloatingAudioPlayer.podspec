#
# Be sure to run `pod lib lint FloatingAudioPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FloatingAudioPlayer'
  s.version          = '0.1.1'
  s.summary          = 'FloatingAudioPlayer is lightweight floating/draggable Audio Player View written in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'FloatingAudioPlayer is lightweight floating/draggable Audio Player View written in Swift.'
                       DESC

  s.homepage         = 'https://github.com/pernebayevz/FloatingAudioPlayer'
  s.screenshots     = 'https://drive.google.com/file/d/1BAQHuH_9FXNGzBNihb6WMemRmvXmmNgv/view?usp=sharing', 'https://drive.google.com/file/d/1Mn0KHzdVQKKxHh-PeGzqm4eGUSvxum74/view?usp=sharing', 'https://drive.google.com/file/d/1c3e81WBne0j70C39FBPktxa0OsmmXQz0/view?usp=sharing'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zhangali Pernebayev' => 'swiftisgreat@gmail.com' }
  s.source           = { :git => 'https://github.com/pernebayevz/FloatingAudioPlayer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/pernebayev/'

  s.ios.deployment_target = '12.0'

  s.source_files = 'Source/**/*.swift'
  s.resource_bundles = {
    'FloatingAudioPlayer' => ['Source/**/*.{xib,xcassets}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.swift_version = '5.0'
  # s.dependency 'AFNetworking', '~> 2.3'
end
