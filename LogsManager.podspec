#
# Be sure to run `pod lib lint LogsManager.podspec` to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LogsManager'
  s.version          = '9.1.14'
  s.summary          = 'Logs manager on top of CocoaLumberjack.'

  s.description      = <<-DESC
Logs manager on top of CocoaLumberjack. Allows to easily configure log components depending on your app infrastucture. Have several convenience loggers: ConsoleLogger, AlertLogger, NotificationLogger.
                       DESC

  s.homepage         = 'https://github.com/APUtils/LogsManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :git => 'https://github.com/APUtils/LogsManager.git', :tag => s.version.to_s }
  
  s.swift_versions = ['5.1']
  s.frameworks = 'Foundation'
  
  s.default_subspec = 'ExtensionUnsafe'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target = '9.0'
  
  s.subspec 'Core' do |subspec|
      subspec.ios.deployment_target = '9.0'
      subspec.osx.deployment_target = '10.10'
      subspec.watchos.deployment_target = '3.0'
      subspec.tvos.deployment_target = '9.0'
      subspec.source_files = 'LogsManager/Classes/**/*', 'LogsManager/Shared/**/*'
      subspec.dependency 'CocoaLumberjack/Swift', '>= 3.7.2'
  end
  
  s.subspec 'ExtensionUnsafe' do |subspec|
      subspec.ios.deployment_target = '9.0'
      subspec.source_files = 'LogsManager/ExtensionUnsafeClasses/**/*', 'LogsManager/Classes/**/*', 'LogsManager/Shared/**/*'
      subspec.dependency 'CocoaLumberjack/Swift', '>= 3.7.2'
  end

end
