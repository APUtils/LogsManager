#
# Be sure to run `pod lib lint LogsManager.podspec` to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RoutableLogger'
  s.version          = '12.3.2'
  s.summary          = 'Logger that allows logs redirection.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Just helper framework that allows logs redirection. It is used in various frameworks and then routed to LogsManager system in the main application.
                       DESC

  s.homepage         = 'https://github.com/APUtils/LogsManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :git => 'https://github.com/APUtils/LogsManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.13'
  s.tvos.deployment_target = '11.0'
  s.watchos.deployment_target = '4.0'
  
  s.swift_versions = ['5.5', '5.5.1', '5.5.2', '5.6', '5.6.1', '5.7']
  s.frameworks = 'Foundation'
  s.source_files = 'LogsManager/RoutableLogger/**/*', 'LogsManager/Shared/**/*'

end
