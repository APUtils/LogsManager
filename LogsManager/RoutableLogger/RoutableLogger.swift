//
//  RoutableRoutableLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation

/// Simple logger that allows redirection.
public enum RoutableLogger {
    
    private static var dateFormatter: DateFormatter = .default
    
    /// Error once log handler.
    /// - parameter message: Message to log.
    /// - parameter error: Error to report.
    /// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
    public static var logErrorOnceHandler: (_ message: () -> (String),
                                            _ error: Any?,
                                            _ data: [String : Any?]?,
                                            _ file: String,
                                            _ function: String,
                                            _ line: UInt) -> Void = _logErrorOnce
    
    /// Error log hadnler.
    /// - parameter message: Message to log.
    /// - parameter error: Error to report.
    /// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
    public static var logErrorHandler: (_ message: () -> (String),
                                        _ error: Any?,
                                        _ data: [String : Any?]?,
                                        _ file: String,
                                        _ function: String,
                                        _ line: UInt) -> Void = _logError
    
    /// Warning log handler.
    public static var logWarningHandler: (_ message: () -> (String),
                                       _ file: String,
                                       _ function: String,
                                       _ line: UInt) -> Void = logMessageHandler
    
    /// Info log handler.
    public static var logInfoHandler: (_ message: () -> (String),
                                       _ file: String,
                                       _ function: String,
                                       _ line: UInt) -> Void = logMessageHandler
    
    /// Debug log handler.
    public static var logDebugHandler: (_ message: () -> (String),
                                        _ file: String,
                                        _ function: String,
                                        _ line: UInt) -> Void = logMessageHandler
    
    /// Verbose log handler.
    public static var logVerboseHandler: (_ message: () -> (String),
                                          _ file: String,
                                          _ function: String,
                                          _ line: UInt) -> Void = logMessageHandler
    
    /// Data log handler.
    public static var logDataHandler: (_ message: () -> (String),
                                       _ file: String,
                                       _ function: String,
                                       _ line: UInt) -> Void = logMessageHandler
    
    /// Info, debug, verbose and data message logs go here if not redirected.
    public static var logMessageHandler: (_ message: () -> (String),
                                          _ file: String,
                                          _ function: String,
                                          _ line: UInt) -> Void = _consoleLog
    
    // ******************************* MARK: - Default Implementations
    
    private struct OnceLogRecord: Hashable {
        let file: String
        let function: String
        let line: UInt
    }
    
    private static var onceLoggedErrors: [OnceLogRecord] = []
    
    private static func _logErrorOnce(_ message: @autoclosure () -> String,
                                      error: Any?,
                                      data: [String : Any?]?,
                                      file: String = #file,
                                      function: String = #function,
                                      line: UInt = #line) {
        
        let record = OnceLogRecord(file: file, function: function, line: line)
        if onceLoggedErrors.contains(record) {
            return
        } else {
            onceLoggedErrors.append(record)
        }
        
        _logError(message(), error: error, data: data, file: file, function: function, line: line)
    }
    
    private static func _logError(_ message: @autoclosure () -> String,
                                  error: Any?,
                                  data: [String : Any?]?,
                                  file: String = #file,
                                  function: String = #function,
                                  line: UInt = #line) {
        
        let message = message()
        let errorString: String
        if let normalizedError = Utils.normalizeError(error) {
            errorString = "\n\(normalizedError)"
        } else {
            errorString = ""
        }
        
        let dataString: String
        if let normalizedData = Utils.normalizeData(data) {
            dataString = "\n\(normalizedData)"
        } else {
            dataString = ""
        }
        
        let timeString = dateFormatter.string(from: Date())
        let logString = "\(timeString) | \(message)\(errorString)\(dataString)"
        
        print(logString)
    }
    
    private static func _consoleLog(_ message: @autoclosure () -> String,
                                    file: String = #file,
                                    function: String = #function,
                                    line: UInt = #line) {
        
        let message = message()
        let timeString = dateFormatter.string(from: Date())
        let logString = "\(timeString) | \(message)"
        
        print(logString)
    }
    
    // ******************************* MARK: - Convenient Methods
    
    /// Error log function.
    /// - parameter message: Message to log.
    /// - parameter error: Error to report.
    /// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
    public static func logError(_ message: @autoclosure () -> String,
                                error: Any? = nil,
                                data: [String: Any?]? = nil,
                                file: String = #file,
                                function: String = #function,
                                line: UInt = #line) {
        
        logErrorHandler(message,
                        error,
                        data,
                        file,
                        function,
                        line)
    }
    
    /// Warning log function.
    /// - parameter message: Message to log.
    public static func logWarning(_ message: @autoclosure () -> String,
                                  file: String = #file,
                                  function: String = #function,
                                  line: UInt = #line) {
        
        logWarningHandler(message,
                          file,
                          function,
                          line)
    }
    
    /// Info log function.
    /// - parameter message: Message to log.
    public static func logInfo(_ message: @autoclosure () -> String,
                               file: String = #file,
                               function: String = #function,
                               line: UInt = #line) {
        
        logInfoHandler(message,
                       file,
                       function,
                       line)
    }
    
    
    /// Debug log function.
    /// - parameter message: Message to log.
    public static func logDebug(_ message: @autoclosure () -> String,
                                file: String = #file,
                                function: String = #function,
                                line: UInt = #line) {
        
        logDebugHandler(message,
                        file,
                        function,
                        line)
    }
    
    /// Verbose log function. This level of logs usually is excessive but may be helpful in some cases.
    /// Use it for repeated logs or logs that are usually not needed to understand what's going on.
    /// - parameter message: Message to log.
    public static func logVerbose(_ message: @autoclosure () -> String,
                                  file: String = #file,
                                  function: String = #function,
                                  line: UInt = #line) {
        
        logVerboseHandler(message,
                          file,
                          function,
                          line)
    }
    
    /// Data log function. This one is to log big chunks of data like network responses.
    /// - parameter message: Message to log.
    public static func logData(_ message: @autoclosure () -> String,
                               file: String = #file,
                               function: String = #function,
                               line: UInt = #line) {
        
        logDataHandler(message,
                       file,
                       function,
                       line)
    }
    
}
