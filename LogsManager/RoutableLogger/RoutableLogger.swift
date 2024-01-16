//
//  RoutableLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation

/// Simple logger that allows redirection.
public enum RoutableLogger {
    
    public typealias DataClosure = () -> [AnyHashable: Any?]?
    
    private static var dateFormatter: DateFormatter = .default
    
    /// Error once log handler.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Log components that may help group a log message.
    /// - parameter error: Error to report.
    /// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
    public static var logErrorOnceHandler: (_ message: () -> (String),
                                            _ logComponents: [String],
                                            _ error: Any?,
                                            _ data: @autoclosure DataClosure,
                                            _ file: String,
                                            _ function: String,
                                            _ line: UInt) -> Void = _logErrorOnce
    
    /// Error log hadnler.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Log components that may help group a log message.
    /// - parameter error: Error to report.
    /// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
    public static var logErrorHandler: (_ message: () -> (String),
                                        _ logComponents: [String],
                                        _ error: Any?,
                                        _ data: @autoclosure DataClosure,
                                        _ file: String,
                                        _ function: String,
                                        _ line: UInt) -> Void = _logError
    
    /// Warning log handler.
    public static var logWarningHandler: (_ message: () -> (String),
                                          _ logComponents: [String],
                                          _ data: @autoclosure DataClosure,
                                          _ file: String,
                                          _ function: String,
                                          _ line: UInt) -> Void = logMessageHandler
    
    /// Info log handler.
    public static var logInfoHandler: (_ message: () -> (String),
                                       _ logComponents: [String],
                                       _ data: @autoclosure DataClosure,
                                       _ file: String,
                                       _ function: String,
                                       _ line: UInt) -> Void = logMessageHandler
    
#if DEBUG
    /// Debug log handler. Outputs in debug builds
    public static var logDebugHandler: (_ message: () -> (String),
                                        _ logComponents: [String],
                                        _ data: @autoclosure DataClosure,
                                        _ file: String,
                                        _ function: String,
                                        _ line: UInt) -> Void = logMessageHandler
#else
    /// Debug log handler. No output in release builds.
    public static var logDebugHandler: (_ message: () -> (String),
                                        _ logComponents: [String],
                                        _ data: @autoclosure DataClosure,
                                        _ file: String,
                                        _ function: String,
                                        _ line: UInt) -> Void = { _, _, _, _, _, _ in }
#endif
    
    /// Verbose log handler. No output by default.
    public static var logVerboseHandler: (_ message: () -> (String),
                                          _ logComponents: [String],
                                          _ data: @autoclosure DataClosure,
                                          _ file: String,
                                          _ function: String,
                                          _ line: UInt) -> Void = { _, _, _, _, _, _ in }
    
    /// Trace log handler. No output by default.
    public static var logTraceHandler: (_ logComponents: [String],
                                        _ file: String,
                                        _ function: String,
                                        _ line: UInt) -> Void = { _, _, _, _ in }
    
    /// Data log handler. No output by default.
    public static var logDataHandler: (_ message: () -> (String),
                                       _ logComponents: [String],
                                       _ data: @autoclosure DataClosure,
                                       _ file: String,
                                       _ function: String,
                                       _ line: UInt) -> Void = { _, _, _, _, _, _ in }
    
    /// Warning, info and debug message logs go here if not redirected.
    public static var logMessageHandler: (_ message: () -> (String),
                                          _ logComponents: [String],
                                          _ data: @autoclosure DataClosure,
                                          _ file: String,
                                          _ function: String,
                                          _ line: UInt) -> Void = _consoleLog
    
    // ******************************* MARK: - Default Implementations
    
    private struct OnceLogRecord: Hashable {
        let file: String
        let line: UInt
    }
    
    private static var onceLoggedErrors = Set<OnceLogRecord>()
    
    private static func _logErrorOnce(_ message: @autoclosure () -> String,
                                      logComponents: [String],
                                      error: Any?,
                                      data: @autoclosure DataClosure,
                                      file: String = #file,
                                      function: String = #function,
                                      line: UInt = #line) {
        
        let record = OnceLogRecord(file: file, line: line)
        if onceLoggedErrors.contains(record) {
            return
        } else {
            onceLoggedErrors.insert(record)
        }
        
        _logError(message(),
                  logComponents: logComponents,
                  error: error,
                  data: data(),
                  file: file,
                  function: function,
                  line: line)
    }
    
    private static func _logError(_ message: @autoclosure () -> String,
                                  logComponents: [String],
                                  error: Any?,
                                  data: @autoclosure DataClosure,
                                  file: String = #file,
                                  function: String = #function,
                                  line: UInt = #line) {
        
        let normalizedData = Utils.normalizeData(data(), skipDataNormalizationKeyPrefix: nil)
        let normalizedError = Utils.normalizeError(error)
        let messageString = Utils.normalizedMessage(message(), normalizedData: normalizedData, normalizedError: normalizedError, oneLine: false)
        
        let errorString = Utils.normalizedErrorString(normalizedError, normalizedData: normalizedData, oneLine: false)
        
        let dataString = Utils.normalizedDataString(normalizedData, oneLine: false)
        let timeString = dateFormatter.string(from: Date())
        let logString = "\(timeString) | \(messageString)\(errorString)\(dataString)"
        
        print(logString)
    }
    
    private static func _consoleLog(_ message: @autoclosure () -> String,
                                    logComponents: [String],
                                    data: @autoclosure DataClosure,
                                    file: String = #file,
                                    function: String = #function,
                                    line: UInt = #line) {
        
        let message = message()
        let timeString = dateFormatter.string(from: Date())
        let dataString = Utils.normalizedDataString(Utils.normalizeData(data(), skipDataNormalizationKeyPrefix: nil), oneLine: false)
        print("\(timeString) | \(message)\(dataString)")
    }
    
    // ******************************* MARK: - Convenient Methods
    
    /// Error log function. Logs error only once for each file-function-line combination.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Log components that may help group a log message.
    /// - parameter error: Error to report.
    /// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
    public static func logErrorOnce(_ message: @autoclosure () -> String,
                                    logComponents: [String] = [],
                                    error: Any? = nil,
                                    data: @autoclosure DataClosure = nil,
                                    file: String = #file,
                                    function: String = #function,
                                    line: UInt = #line) {
        
        logErrorOnceHandler(message,
                            logComponents,
                            error,
                            data(),
                            file,
                            function,
                            line)
    }
    
    /// Error log function.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Log components that may help group a log message.
    /// - parameter error: Error to report.
    /// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
    public static func logError(_ message: @autoclosure () -> String,
                                logComponents: [String] = [],
                                error: Any? = nil,
                                data: @autoclosure DataClosure = nil,
                                file: String = #file,
                                function: String = #function,
                                line: UInt = #line) {
        
        logErrorHandler(message,
                        logComponents,
                        error,
                        data(),
                        file,
                        function,
                        line)
    }
    
    /// Warning log function.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Log components that may help group a log message.
    /// - parameter data: Additional data to log.
    public static func logWarning(_ message: @autoclosure () -> String,
                                  logComponents: [String] = [],
                                  data: @autoclosure DataClosure = nil,
                                  file: String = #file,
                                  function: String = #function,
                                  line: UInt = #line) {
        
        logWarningHandler(message,
                          logComponents,
                          data(),
                          file,
                          function,
                          line)
    }
    
    /// Info log function.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Log components that may help group a log message.
    /// - parameter data: Additional data to log.
    public static func logInfo(_ message: @autoclosure () -> String,
                               logComponents: [String] = [],
                               data: @autoclosure DataClosure = nil,
                               file: String = #file,
                               function: String = #function,
                               line: UInt = #line) {
        
        logInfoHandler(message,
                       logComponents,
                       data(),
                       file,
                       function,
                       line)
    }
    
    
    /// Debug log function.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Log components that may help group a log message.
    /// - parameter data: Additional data to log.
    public static func logDebug(_ message: @autoclosure () -> String,
                                logComponents: [String] = [],
                                data: @autoclosure DataClosure = nil,
                                file: String = #file,
                                function: String = #function,
                                line: UInt = #line) {
        
        logDebugHandler(message,
                        logComponents,
                        data(),
                        file,
                        function,
                        line)
    }
    
    /// Verbose log function. This level of logs usually is excessive but may be helpful in some cases.
    /// Use it for repeated logs or logs that are usually not needed to understand what's going on.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Log components that may help group a log message.
    /// - parameter data: Additional data to log.
    public static func logVerbose(_ message: @autoclosure () -> String,
                                  logComponents: [String] = [],
                                  data: @autoclosure DataClosure = nil,
                                  file: String = #file,
                                  function: String = #function,
                                  line: UInt = #line) {
        
        logVerboseHandler(message,
                          logComponents,
                          data(),
                          file,
                          function,
                          line)
    }
    
    /// Trace log function. This one is to trace execution path. Usually, the log should be placed as the first line in the method or function.
    /// - parameter logComponents: Components this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
    public static func logTrace(logComponents: [String] = [],
                         file: String = #file,
                         function: String = #function,
                         line: UInt = #line) {
        
        logTraceHandler(logComponents,
                        file,
                        function,
                        line)
    }
    
    /// Data log function. This one is to log big chunks of data like network responses.
    /// - parameter message: Message to log.
    /// - parameter logComponents: Log components that may help group a log message.
    /// - parameter data: Additional data to log. 
    public static func logData(_ message: @autoclosure () -> String,
                               logComponents: [String] = [],
                               data: @autoclosure DataClosure = nil,
                               file: String = #file,
                               function: String = #function,
                               line: UInt = #line) {
        
        logDataHandler(message,
                       logComponents,
                       data(),
                       file,
                       function,
                       line)
    }
    
}
