//
//  LoggersManager.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation
import RoutableLogger
import Dispatch

#if COCOAPODS
import CocoaLumberjack
#else
import CocoaLumberjackSwift
#endif

/// Central point for all application logs.
/// You can easily change how logs will be displayed or processed here.
open class LoggersManager {
    
    public typealias DataClosure = () -> [AnyHashable: Any?]?
    public typealias TimestampClosure = () -> Date
    
    public struct OnceLogRecord: Hashable {
        let file: String
        let line: UInt
        
        public init(file: String, line: UInt) {
            self.file = file
            self.line = line
        }
    }
    
    // ******************************* MARK: - Singleton
    
    public static var shared: LoggersManager = LoggersManager()
    
    // ******************************* MARK: - Properties
    
    /// Global messages async/sync log flag. Default is `true`.
    public static var logMessagesAsync: Bool = true
    
    private var isPaused: Bool = false
    private var pausedLogs: [() -> Void] = []
    
    private var loggers: [BaseLogger] = []
    public private(set) var logComponentByName: [String: LogComponent] = [:]
    private var combinedLogLevel: DDLogLevel = .off
    private var cachedComponents: [ComponentsKey: [LogComponent]] = [:]
    private let queue = DispatchQueue(label: "LoggersManager")
    private var onceLoggedErrors = Set<OnceLogRecord>()
    
    /// Default file logger. You can adjust its parameters if needed.
    /// By default, each app session corresponds to individual file, max logs size is 300 MB
    /// and all logs are saved.
    public private(set) lazy var fileLogger: FileLogger = {
        
        // Record all logs into file
        let fileLogger = FileLogger(mode: .all, logLevel: .all)
        
        // Each app session should correspond to one log file
        fileLogger.maximumFileSize = .max
        fileLogger.doNotReuseLogFiles = true
        fileLogger.rollingFrequency = .greatestFiniteMagnitude
        fileLogger.logFileManager.logFilesDiskQuota = 300 * 1024 * 1024 // 300 MB
        fileLogger.logFileManager.maximumNumberOfLogFiles = .max
        
        // Log logs file destination on simulators for ease access during debug sessions.
#if !targetEnvironment(simulator)
        RoutableLogger.logInfo("Log file path: '\(fileLogger.currentLogFileInfo?.filePath ?? "nil")'")
#endif
        
        return fileLogger
    }()
    
    // ******************************* MARK: - Public Methods
    
    /// Pauses delivery of logs to loggers. All received logs are preserved and delivered on the `resume()` call.
    /// This is convenient to use to prevent logs lose for example on the app start when some loggers
    /// might not yet be possible to initialize or launch.
    public func pause() {
        queue.performSync {
            guard isPaused == false else {
                RoutableLogger.logError("Unable to pause logs delivery. It's already paused.")
                return
            }
            
            isPaused = true
        }
    }
    
    /// Triggers delivery of all delayed logs due to `pause()` call and resumes logs delivery to loggers.
    public func resume() {
        queue.performSync { [self] in
            guard isPaused else {
                RoutableLogger.logError("Unable to resume logs delivery. It's already working.")
                return
            }
            
            isPaused = false
        }
        
        // Send paused logs outside on queue to prevent deadlock.
        // We shouldn't access our public methods from the queue and that's what paused logs do.
        pausedLogs.forEach { $0() }
        pausedLogs = []
    }
    
    private func addPausedLog(sendLogAction: @escaping (() -> Void)) {
        queue.async { [self] in
            if isPaused {
                pausedLogs.append(sendLogAction)
                
            } else {
                sendLogAction()
            }
        }
    }
    
    /// Registers log component for detection
    public func registerLogComponent(_ logComponent: LogComponent) {
        queue.performSync {
            guard logComponentByName[logComponent.name] == nil else {
                RoutableLogger.logError("Log component '\(logComponent)' was already added")
                return
            }
            
            logComponentByName[logComponent.name] = logComponent
            cachedComponents = [:]
        }
    }
    
    /// Uregisters log component from detection
    public func unregisterLogComponent(_ logComponent: LogComponent) {
        queue.performSync {
            guard logComponentByName[logComponent.name] != nil else {
                RoutableLogger.logError("Log component '\(logComponent)' is not added")
                return
            }
            
            logComponentByName[logComponent.name] = nil
            cachedComponents = [:]
        }
    }
    
    /// Adds text logger. Do nothing if logger with the same log level is already added.
    public func addLogger(_ logger: BaseLogger) {
        queue.performSync {
            guard !loggers.contains(where: { $0 === logger }) else { return }
            
            loggers.append(logger)
            DDLog.add(logger, with: logger.logLevel)
            
            combinedLogLevel = DDLogLevel(rawValue: combinedLogLevel.rawValue | logger.logLevel.rawValue)!
        }
    }
    
    /// Removes text logger
    public func removeLogger(_ logger: BaseLogger) {
        queue.performSync {
            guard loggers.contains(where: { $0 === logger }) else { return }
            
            loggers.removeAll(where: { $0 === logger })
            DDLog.remove(logger)
            
            let rawCombinedLogLevel = loggers
                .map { $0.logLevel.rawValue }
                .reduce(0) { $0 | $1 }
            
            combinedLogLevel = DDLogLevel(rawValue: rawCombinedLogLevel)!
        }
    }
    
    /// Adds default file logger. Check `fileLogger` property for more details.
    public func addFileLogger() {
        addLogger(fileLogger)
    }
    
    /// Removes previously added `fileLogger`.
    public func removeFileLogger() {
        removeLogger(fileLogger)
    }
    
    /// Log message function.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Components this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
    /// - parameter flag: Log level, e.g. `.error`, `.debug`, ...
    /// - parameter data: Data to attach to the message.
    /// - parameter asynchronous: Async or sync logs. Default is `nil` and global flag is used.
    public func logMessage(_ message: @autoclosure () -> String,
                           logComponents: [LogComponent]? = nil,
                           flag: DDLogFlag,
                           data: @autoclosure DataClosure = nil,
                           asynchronous: Bool? = nil,
                           timestamp: @autoclosure TimestampClosure = Date(),
                           file: String = #file,
                           function: String = #function,
                           line: UInt = #line) {
        
        let asynchronous = asynchronous ?? Self.logMessagesAsync
        
        // We don't use queue here to speed up things but we need to copy value to prevent threading issues.
        let isPaused = self.isPaused
        if isPaused {
            // We don't know if this log should be processed or not so we just process everything until we resume.
            // Usually this shouldn't take much time and we shouldn't have much logs during that period.
            let message = message()
            let data = data()
            let timestamp = timestamp()
            addPausedLog { [self] in
                logMessage(message,
                           logComponents: logComponents,
                           flag: flag,
                           data: data,
                           asynchronous: asynchronous,
                           timestamp: timestamp,
                           file: file,
                           function: function,
                           line: line)
            }
            return
        }
        
        // We don't use queue here to speed up things but we need to copy value to prevent threading issues.
        // Check if combined log level allows this message to pass
        let combinedLogLevel = self.combinedLogLevel
        guard combinedLogLevel.rawValue & flag.rawValue != 0 else { return }
        
        // -------- Copied from `CocoaLumberjack.swift`
        // The `dynamicLogLevel` will always be checked here (instead of being passed in).
        // We cannot "mix" it with the `DDDefaultLogLevel`, because otherwise the compiler won't strip strings that are not logged.
        if dynamicLogLevel.rawValue & flag.rawValue != 0 {
            let logComponents = logComponents ?? detectLogComponent(filePath: file, function: function, line: line)
            let parameters = DDLogMessage.Parameters(data: data(), error: nil, logComponents: logComponents)
            
            // Tell the DDLogMessage constructor to copy the C strings that get passed to it.
            let message = message()
            let logMessage = DDLogMessage(format: message,
                                          formatted: message,
                                          level: DDLogLevel(flag: flag),
                                          flag: flag,
                                          context: 0,
                                          file: file,
                                          function: function,
                                          line: line,
                                          tag: parameters,
                                          options: [.dontCopyMessage],
                                          timestamp: timestamp())
            
            logIfNeeded(asynchronous: asynchronous, message: logMessage)
        }
        // --------
    }
    
    /// Logs error only once for each file-function-line combination.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Components this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
    /// - parameter error: Error that occured.
    /// - parameter data: Data to attach to error.
    /// - parameter flag: Log level, e.g. `.error`, `.debug`, ...
    /// - parameter asynchronous: Async or sync logs. Default is `nil` and global flag is used.
    public func logErrorOnce(_ message: @autoclosure () -> String,
                             logComponents: [LogComponent]? = nil,
                             error: Any?,
                             data: @autoclosure DataClosure = nil,
                             asynchronous: Bool? = nil,
                             timestamp: @autoclosure TimestampClosure = Date(),
                             file: String = #file,
                             function: String = #function,
                             line: UInt = #line) {
        
        let asynchronous = asynchronous ?? Self.logMessagesAsync
        
        // We don't use queue here to speed up things but we need to copy value to prevent threading issues.
        let isPaused = self.isPaused
        if isPaused {
            // We don't know if this log should be processed or not so we just process everything until we resume.
            // Usually this shouldn't take much time and we shouldn't have much logs during that period.
            let message = message()
            let data = data()
            let timestamp = timestamp()
            addPausedLog { [self] in
                logErrorOnce(message,
                             logComponents: logComponents,
                             error: error,
                             data: data,
                             asynchronous: asynchronous,
                             timestamp: timestamp,
                             file: file,
                             function: function,
                             line: line)
            }
            return
        }
        
        let record = OnceLogRecord(file: file, line: line)
        if queue.performSync(execute: { onceLoggedErrors.contains(record) }) {
            return
        } else {
            queue.async(flags: .barrier) {
                self.onceLoggedErrors.insert(record)
            }
        }
        
        // We don't use queue here to speed up things but we need to copy value to prevent threading issues.
        // Check if combined log level allows this error to pass
        let combinedLogLevel = self.combinedLogLevel
        guard combinedLogLevel.rawValue & DDLogFlag.error.rawValue != 0 else { return }
        
        // -------- Copied from `CocoaLumberjack.swift`
        // The `dynamicLogLevel` will always be checked here (instead of being passed in).
        // We cannot "mix" it with the `DDDefaultLogLevel`, because otherwise the compiler won't strip strings that are not logged.
        if dynamicLogLevel.rawValue & DDLogFlag.error.rawValue != 0 {
            let logComponents = logComponents ?? detectLogComponent(filePath: file, function: function, line: line)
            let parameters = DDLogMessage.Parameters(data: data(), error: error, logComponents: logComponents)
            
            // Tell the DDLogMessage constructor to copy the C strings that get passed to it.
            let message = message()
            let logMessage = DDLogMessage(format: message,
                                          formatted: message,
                                          level: .error,
                                          flag: .error,
                                          context: 0,
                                          file: file,
                                          function: function,
                                          line: line,
                                          tag: parameters,
                                          options: [.dontCopyMessage],
                                          timestamp: timestamp())
            
            logIfNeeded(asynchronous: asynchronous, message: logMessage)
        }
        // --------
    }
    
    /// Log error function.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Components this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
    /// - parameter error: Error that occured.
    /// - parameter data: Data to attach to error.
    /// - parameter flag: Log level, e.g. `.error`, `.debug`, ...
    /// - parameter asynchronous: Async logs. Default is `false`.
    public func logError(_ message: @autoclosure () -> String,
                         logComponents: [LogComponent]? = nil,
                         error: Any?,
                         data: @autoclosure DataClosure = nil,
                         asynchronous: Bool? = nil,
                         timestamp: Date = Date(),
                         file: String = #file,
                         function: String = #function,
                         line: UInt = #line) {
        
        let asynchronous = asynchronous ?? Self.logMessagesAsync
        
        // We don't use queue here to speed up things but we need to copy value to prevent threading issues.
        let isPaused = self.isPaused
        if isPaused {
            // We don't know if this log should be processed or not so we just process everything until we resume.
            // Usually this shouldn't take much time and we shouldn't have much logs during that period.
            let message = message()
            let data = data()
            addPausedLog { [self] in
                logError(message,
                         logComponents: logComponents,
                         error: error,
                         data: data,
                         asynchronous: asynchronous,
                         timestamp: timestamp,
                         file: file,
                         function: function,
                         line: line)
            }
            return
        }
        
        // We don't use queue here to speed up things but we need to copy value to prevent threading issues.
        // Check if combined log level allows this error to pass
        let combinedLogLevel = self.combinedLogLevel
        guard combinedLogLevel.rawValue & DDLogFlag.error.rawValue != 0 else { return }
        
        // -------- Copied from `CocoaLumberjack.swift`
        // The `dynamicLogLevel` will always be checked here (instead of being passed in).
        // We cannot "mix" it with the `DDDefaultLogLevel`, because otherwise the compiler won't strip strings that are not logged.
        if dynamicLogLevel.rawValue & DDLogFlag.error.rawValue != 0 {
            let logComponents = logComponents ?? detectLogComponent(filePath: file, function: function, line: line)
            let parameters = DDLogMessage.Parameters(data: data(), error: error, logComponents: logComponents)
            
            // Tell the DDLogMessage constructor to copy the C strings that get passed to it.
            let message = message()
            let logMessage = DDLogMessage(format: message,
                                          formatted: message,
                                          level: .error,
                                          flag: .error,
                                          context: 0,
                                          file: file,
                                          function: function,
                                          line: line,
                                          tag: parameters,
                                          options: [.dontCopyMessage],
                                          timestamp: timestamp)
            
            logIfNeeded(asynchronous: asynchronous, message: logMessage)
        }
        // --------
    }
    
    // ******************************* MARK: - Private Methods
    
    /// Returns auto-detected log components
    public func detectLogComponent(filePath: String, function: String, line: UInt) -> [LogComponent] {
        // Return hash if we have
        let key = ComponentsKey(filePath: filePath, function: function, line: line)
        let existingCachedComponents: [LogComponent]? = queue.performSync {
            if let cachedComponents = cachedComponents[key] {
                return cachedComponents
            } else {
                return nil
            }
        }
        
        if let existingCachedComponents = existingCachedComponents {
            return existingCachedComponents
        }
        
        var components: [LogComponent] = logComponentByName.values.filter { logComponent in
            let path = String(filePath)
            let file = String.getFileName(filePath: path)
            let function = String(function)
            return logComponent.isLogForThisComponent(path, file, function)
        }
        
        if components.isEmpty {
            components.append(.unspecified)
        }
        
        queue.async(flags: .barrier) {
            self.cachedComponents[key] = components
        }
        
        return components
    }
    
    private func logIfNeeded(asynchronous: Bool, message: DDLogMessage) {
        guard loggers.contains(where: { $0.shouldLog(message: message) }) else { return }
        
        // We might have a deadlock if we try to log on a logger queue so let's check
        if !asynchronous {
            let deadlockLoggers = loggers.filter { ($0 as? DDAbstractLogger)?.isOnInternalLoggerQueue == true }
            if deadlockLoggers.count > 0 {
                self.logErrorOnce("Logging deadlock",
                                  error: nil,
                                  data: ["deadlockLoggers": deadlockLoggers,
                                         "asynchronous": asynchronous,
                                         "logMessagesAsync": Self.logMessagesAsync,
                                         "explanation": "this is happening when a logger trying to log a message on its inner queue while global logging queue is already blocked. Please make sure there are no logs during log processing or make them async.",
                                         "message": message.message],
                                  asynchronous: true)
                DDLog.sharedInstance.log(asynchronous: true, message: message)
                return
            }
        }
        
        DDLog.sharedInstance.log(asynchronous: asynchronous, message: message)
    }
}

private struct ComponentsKey: Equatable, Hashable {
    let filePath: String
    let function: String
    let line: UInt
}

// ******************************* MARK: - Private Extensions

private var c_keyAssociationKey = 0

private extension DispatchQueue {
    
    private var key: DispatchSpecificKey<Void> {
        get {
            if let key = objc_getAssociatedObject(self, &c_keyAssociationKey) as? DispatchSpecificKey<Void> {
                return key
            } else {
                let key = DispatchSpecificKey<Void>()
                setSpecific(key: key, value: ())
                objc_setAssociatedObject(self, &c_keyAssociationKey, key, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return key
            }
        }
        set {
            objc_setAssociatedObject(self, &c_keyAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Performs `work` on `self` synchronously. Just performs `work` if already on a `self.`
    func performSync<T>(execute work: () throws -> T) rethrows -> T {
        if DispatchQueue.getSpecific(key: key) != nil {
            return try work()
        } else {
            return try sync { try work() }
        }
    }
}
