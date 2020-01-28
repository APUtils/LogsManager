# LogsManager

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/LogsManager.svg?style=flat)](http://cocoapods.org/pods/LogsManager)
[![License](https://img.shields.io/cocoapods/l/LogsManager.svg?style=flat)](http://cocoapods.org/pods/LogsManager)
[![Platform](https://img.shields.io/cocoapods/p/LogsManager.svg?style=flat)](http://cocoapods.org/pods/LogsManager)
[![CI Status](http://img.shields.io/travis/APUtils/LogsManager.svg?style=flat)](https://travis-ci.org/APUtils/LogsManager)

Logs manager on top of CocoaLumberjack. Allows to easily configure log components depending on your app infrastucture. Have several convenience loggers: ConsoleLogger, AlertLogger, NotificationLogger.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

#### Carthage

Please check [official guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

Cartfile:

```
github "APUtils/LogsManager" ~> 8.0
```

Add `LogsManager` framework. Add `LogsManagerExtensionUnsafe` framework for the main app only.

#### CocoaPods

LogsManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

Default:
```ruby
pod 'LogsManager', '~> 8.0'
```

App extension safe version:
```ruby
pod 'LogsManager/Core', '~> 8.0'
```

## Usage

You have to add logs component first if you want your logs to be separated by components:
```swift
let vcComponent = LogComponent(name: "ViewController", logName: "VC") { filePath, _ in
    let fileName = String.getFileName(filePath: filePath)
    return fileName == "ViewController"
}
LoggersManager.shared.registerLogComponent(vcComponent)

let didAppearComponent = LogComponent(name: "Did Appear", logName: "viewDidAppear") { _, function in
    return function.hasPrefix("viewDidAppear")
}
LoggersManager.shared.registerLogComponent(didAppearComponent)
```

Then you need to add loggers and specify their components and log levels:
```swift
// Log all ViewController debug messages
let logger = ConsoleLogger(logComponents: [vcComponent], logLevel: .debug, newLinesSeparation: false)
LoggersManager.shared.addTextLogger(logger)

// Present alert for any error log
let allAlertLogger = AlertLogger(logComponents: nil, logLevel: .error)
LoggersManager.shared.addTextLogger(allAlertLogger)
```

You can use convenience global function to leave logs:
```swift
logInfo("Staring network request to: \(request.url)")
logDebug("Received data")
logVerbose("Data payload: \(data)")
logError("Got error response", error: error, data: ["request": request])
```

See example and test projects for more details.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

LogsManager is available under the MIT license. See the LICENSE file for more info.
