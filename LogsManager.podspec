#
# Be sure to run `pod lib lint LogsManager.podspec` to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LogsManager'
  s.version          = '9.1.0'
  s.summary          = 'Logs manager on top of CocoaLumberjack.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Logs manager on top of CocoaLumberjack. Allows to easily configure log components depending on your app infrastucture. Have several convenience loggers: ConsoleLogger, AlertLogger, NotificationLogger.
                       DESC

  s.homepage         = 'https://github.com/APUtils/LogsManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :git => 'https://github.com/APUtils/LogsManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_versions = ['5.1']
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'CocoaLumberjack/Swift'
  s.source_files = 'LogsManager/**/*'
  
  s.subspec 'Core' do |subspec|
      subspec.source_files = 'LogsManager/Classes/**/*', 'LogsManager/Shared/**/*'
  end
  
  s.subspec 'ExtensionUnsafe' do |subspec|
      subspec.source_files = 'LogsManager/ExtensionUnsafeClasses/**/*'
      subspec.dependency 'LogsManager/Core'
  end
  
  s.subspec 'RoutableLogger' do |subspec|
      subspec.source_files = 'LogsManager/RoutableLogger/**/*', 'LogsManager/Shared/**/*'
  end

end
