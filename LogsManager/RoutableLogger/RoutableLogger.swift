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
    
    /// Error log hadnler.
    /// - parameter message: Message to log.
    /// - parameter error: Error to report.
    /// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
    public static var logError: (_ message: () -> (String),
                                 _ error: Any?,
                                 _ data: [String : Any?]?,
                                 _ file: String,
                                 _ function: String,
                                 _ line: UInt) -> Void = _logError
    
    /// Info log handler.
    public static var logInfo: (_ message: () -> (String),
                                _ file: String,
                                _ function: String,
                                _ line: UInt) -> Void = logMessage
    
    /// Debug log handler.
    public static var logDebug: (_ message: () -> (String),
                                 _ file: String,
                                 _ function: String,
                                 _ line: UInt) -> Void = logMessage
    
    /// Verbose log handler.
    public static var logVerbose: (_ message: () -> (String),
                                   _ file: String,
                                   _ function: String,
                                   _ line: UInt) -> Void = logMessage
    
    /// Data log handler.
    public static var logData: (_ message: () -> (String),
                                _ file: String,
                                _ function: String,
                                _ line: UInt) -> Void = logMessage
    
    /// Info, debug, verbose and data message logs go here if not redirected.
    public static var logMessage: (_ message: () -> (String),
                                   _ file: String,
                                   _ function: String,
                                   _ line: UInt) -> Void = _consoleLog
    
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
}

/// Error log function.
/// - parameter message: Message to log.
/// - parameter error: Error to report.
/// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
func logError(_ message: @autoclosure () -> String,
              error: Any? = nil,
              data: [String: Any?]? = nil,
              file: String = #file,
              function: String = #function,
              line: UInt = #line) {
    
    RoutableLogger.logError(message,
                    error,
                    data,
                    file,
                    function,
                    line)
}

/// Info log function.
/// - parameter message: Message to log.
func logInfo(_ message: @autoclosure () -> String,
             file: String = #file,
             function: String = #function,
             line: UInt = #line) {
    
    RoutableLogger.logInfo(message,
                   file,
                   function,
                   line)
}


/// Debug log function.
/// - parameter message: Message to log.
func logDebug(_ message: @autoclosure () -> String,
              file: String = #file,
              function: String = #function,
              line: UInt = #line) {
    
    RoutableLogger.logDebug(message,
                    file,
                    function,
                    line)
}

/// Verbose log function. This level of logs usually is excessive but may be helpful in some cases.
/// Use it for repeated logs or logs that are usually not needed to understand what's going on.
/// - parameter message: Message to log.
func logVerbose(_ message: @autoclosure () -> String,
                file: String = #file,
                function: String = #function,
                line: UInt = #line) {
    
    RoutableLogger.logVerbose(message,
                      file,
                      function,
                      line)
}

/// Data log function. This one is to log big chunks of data like network responses.
/// - parameter message: Message to log.
func logData(_ message: @autoclosure () -> String,
             file: String = #file,
             function: String = #function,
             line: UInt = #line) {
    
    RoutableLogger.logData(message,
                   file,
                   function,
                   line)
}
