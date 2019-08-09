# Change Log
All notable changes to this project will be documented in this file.
`LogsManager` adheres to [Semantic Versioning](http://semver.org/).


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
