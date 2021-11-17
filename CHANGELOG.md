# Change Log
All notable changes to this project will be documented in this file.
`LogsManager` adheres to [Semantic Versioning](http://semver.org/).


## [10.0.0](https://github.com/APUtils/LogsManager/releases/tag/10.0.0)
Released on 11/17/2021.

#### Changed
- Do not add empty user info to error data

#### Removed
- Carthage support is removed


## [9.1.20](https://github.com/APUtils/LogsManager/releases/tag/9.1.20)
Released on 11/17/2021.

#### Added
- [Carthage] Use XCFrameworks

#### Deprecation
- Carthage is deprecated and will be removed in the `10.0.0` version


## [9.1.19](https://github.com/APUtils/LogsManager/releases/tag/9.1.16)
Released on 11/17/2021.

#### Added
- [RoutableLogger] Carthage support for all platforms


## [9.1.13](https://github.com/APUtils/LogsManager/releases/tag/9.1.13)
Released on 11/16/2021.

#### Added
- [RoutableLogger] SPM support


## [9.1.12](https://github.com/APUtils/LogsManager/releases/tag/9.1.12)
Released on 11/16/2021.

#### Added
- Add error debug description if it differs from default description under "debugDescription" key in data
- Add error user info as "errorUserInfoJSON" or "errorUserInfo" if present
- osX, tvOS and watchOS support
- [RoutableLogger] logErrorOnceHandler and logErrorOnce

#### Changed
- Lowered iOS deployment target to 9.0
- [RoutableLogger] No output by default for data and verbose logs
- [RoutableLogger] Output debug logs during develop builds only
- [RoutableLogger] separation from LogsManager

### Fixed
- [LogsManager] Deadlock fix on double resume call


## [9.1.8](https://github.com/APUtils/LogsManager/releases/tag/9.1.8)
Released on 09/26/2021.

#### Removed
- ExtensionSafe podspec
- APPLICATION_EXTENSION_API_ONLY config for subspecs


## [9.1.7](https://github.com/APUtils/LogsManager/releases/tag/9.1.7)
Released on 09/26/2021.

#### Added
- ExtensionSafe podspec
- APPLICATION_EXTENSION_API_ONLY config for subspecs


## [9.1.6](https://github.com/APUtils/LogsManager/releases/tag/9.1.6)
Released on 09/26/2021.

#### Added
- Allow to use per logger custom date formatters
- Global async/sync message log flag - LoggersManager.logMessagesAsync
- Auto-add localized description parameter to error data if it differ from the error message
- Log errors sync and allow to alter this behavior via parameter
- Log messages async and allow to alter this behavior via parameter
- Logs pause/resume logic
- logWarning for RoutableLogger


## [9.1.5](https://github.com/APUtils/LogsManager/releases/tag/9.1.5)
Released on 03/20/2021.

#### Fixed
- Excessive CocoaLumberjack dependency for RoutableLogger subspec


## [9.1.4](https://github.com/APUtils/LogsManager/releases/tag/9.1.4)
Released on 03/20/2021.

#### Changed
- Replaced RoutableLogger log functions with static methods


## [9.1.3](https://github.com/APUtils/LogsManager/releases/tag/9.1.3)
Released on 03/20/2021.

#### Fixed
- Public access
- Carthage


## [9.1.0](https://github.com/APUtils/LogsManager/releases/tag/9.1.0)
Released on 03/20/2021.

#### Added
- Log level check for logError
- Log level message filter to prevent performance impact
- logErrorOnce method and function

#### Fixed
- Logger remove

#### Improved
- Concurrency safety
- Generate normalized data and error during log message creation
- Prevent excessive copy
- String.getFileName(filePath:) speed up


## [9.0.0](https://github.com/APUtils/LogsManager/releases/tag/9.0.0)
Released on 11/06/2020.

#### Changed
- Dropped iOS 8.0 support
- Latest Lumberjack support


## [8.0.0](https://github.com/APUtils/LogsManager/releases/tag/8.0.0)
Released on 01/28/2020.

#### Added
- CrashLogger
- LogsManager .fileLogger
- LogsManager .addFileLogger()
- LogsManager .removeFileLogger()

#### Changed
- Moved to String from StaticString type
- Separated extension safe and unsafe parts


## [7.2.1](https://github.com/APUtils/LogsManager/releases/tag/7.2.1)
Released on 11/26/2019.

#### Added
- Initialize log component


## [7.2.0](https://github.com/APUtils/LogsManager/releases/tag/7.2.0)
Released on 08/27/2019.

#### Added
- Mute logger mode

#### Fixed
- Message log level corresponds to its flag


## [7.1.0](https://github.com/APUtils/LogsManager/releases/tag/7.1.0)
Released on 08/16/2019.

#### Added
- Added ability to specify specific components with specific log levels for them


## [7.0.0](https://github.com/APUtils/LogsManager/releases/tag/7.0.0)
Released on 08/16/2019.

#### Added
- File name parameter for log component detection


## [6.1.0](https://github.com/APUtils/LogsManager/releases/tag/6.1.0)
Released on 08/16/2019.

#### Added
- Restored ability to pass log components as a parameter if needed


## [6.0.3](https://github.com/APUtils/LogsManager/releases/tag/6.0.3)
Released on 08/15/2019.

#### Fixed
- Fixed console logger missed data and error texts


## [6.0.2](https://github.com/APUtils/LogsManager/releases/tag/6.0.2)
Released on 08/15/2019.

#### Fixed
- Public properties in `DDLogMessage.Parameters`


## [6.0.1](https://github.com/APUtils/LogsManager/releases/tag/6.0.1)
Released on 08/14/2019.

#### Fixed
- Public `normalizedData` and `normalizedError` in `DDLogMessage.Parameters`


## [6.0.0](https://github.com/APUtils/LogsManager/releases/tag/6.0.0)
Released on 08/14/2019.

#### Changed
- `DDLogMessage` `tag` property holds `Parameters` instead of array of log components
- BaseAbstractTextLogger now also adds error description and data description to a formatted message

#### Removed
- Removed ErrorLogger protocol. You can instead inherit from `DDAbstractLogger`, conform to `BaseLogger` and override `log(message:)`. You can access needed parameters using `message.parameters`.

#### Renamed
- BaseTextLogger -> BaseLogger
- BaseAbstractLogger -> BaseAbstractTextLogger


## [5.0.0](https://github.com/APUtils/LogsManager/releases/tag/5.0.0)
Released on 08/09/2019.

#### Added
- Logger mode documentation
- Deinitialize component doc

#### Changed
- Log name for deinit component
- Removed first parameter name for all global log functions


## [4.1.4](https://github.com/APUtils/LogsManager/releases/tag/4.1.4)
Released on 07/02/2019.

#### Fixed
- Concurrency crash fix


## [4.1.3](https://github.com/APUtils/LogsManager/releases/tag/4.1.3)
Released on 06/26/2019.

#### Fixed
- Concurrency crash fix


## [4.1.2](https://github.com/APUtils/LogsManager/releases/tag/4.1.2)
Released on 06/24/2019.

#### Fixed
- Intersection check fix


## [4.1.1](https://github.com/APUtils/LogsManager/releases/tag/4.1.1)
Released on 06/06/2019.

#### Fixed
- Restored original log formatting
- Fixed log message when error log doesn't contain any data


## [4.1.0](https://github.com/APUtils/LogsManager/releases/tag/4.1.0)
Released on 06/05/2019.

#### Changed
- Different message format for file logs to simplify working with them using stream processing

#### Removed
- Removed newLinesSeparation for file logger


## [4.0.1](https://github.com/APUtils/LogsManager/releases/tag/4.0.1)
Released on 06/05/2019.

#### Added
- FileLogger to log into files


## [4.0.0](https://github.com/APUtils/LogsManager/releases/tag/4.0.0)
Released on 06/05/2019.

#### Changed
- Loggers can be configured to log all components, listen to specific components or ignore some of them
- Removed excessive flag param for error logs


## [3.1.0](https://github.com/APUtils/LogsManager/releases/tag/3.1.0)
Released on 06/04/2019.

#### Changed
- Made parameters for component decision ordinary Strings.


## [3.0.1](https://github.com/APUtils/LogsManager/releases/tag/3.0.1)
Released on 06/03/2019.

#### Added
- Log components simple cache


## [3.0.0](https://github.com/APUtils/LogsManager/releases/tag/3.0.0)
Released on 06/03/2019.

#### Changed
- Removed `logComponents` param from all logs. Log components should be autodetected.


## [2.0.0](https://github.com/APUtils/LogsManager/releases/tag/2.0.0)
Released on 05/30/2019.

#### Added
- Swift 5 support
  

## [1.0.0](https://github.com/APUtils/LogsManager/releases/tag/1.0.0)
Released on 02/11/2019.

#### Added
- Initial release of LogsManager.
  - Added by [Anton Plebanovich](https://github.com/anton-plebanovich).
