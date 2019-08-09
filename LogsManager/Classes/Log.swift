//
//  Log.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation

import CocoaLumberjack


/// Error log function. Also send error to crash tracking systems.
/// - parameter message: Message to log.
public func logError(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    logError(message(), error: nil, data: nil, file: file, function: function, line: line)
}

/// Error log function. Also send error to crash tracking systems.
/// - parameter message: Message to log.
/// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
public func logError(_ message: @autoclosure () -> String,
              data: [String: Any?]?,
              file: StaticString = #file,
              function: StaticString = #function,
              line: UInt = #line) {
    logError(message(), error: nil, data: data, file: file, function: function, line: line)
}

/// Error log function. Also send error to crash tracking systems.
/// - parameter message: Message to log.
/// - parameter error: Error that happened.
public func logError(_ message: @autoclosure () -> String, error: Any?, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    logError(message(), error: error, data: nil, file: file, function: function, line: line)
}

/// Error log function.
/// - parameter reason: Message to log.
/// - parameter flag: Log level, e.g. `.error`, `.debug`, ...
/// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
public func logError(_ message: @autoclosure () -> String,
              error: Any?,
              data: [String: Any?]?,
              file: StaticString = #file,
              function: StaticString = #function,
              line: UInt = #line) {
    
    LoggersManager.shared.logError(message(), error: error, data: data, file: file, function: function, line: line)
}

/// Warning log function.
/// - parameter message: Message to log.
public func logWarning(_ message: @autoclosure () -> String,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {
    
    logMessage(message(), flag: .warning, file: file, function: function, line: line)
}

/// Info log function.
/// - parameter message: Message to log.
public func logInfo(_ message: @autoclosure () -> String,
             file: StaticString = #file,
             function: StaticString = #function,
             line: UInt = #line) {
    
    logMessage(message(), flag: .info, file: file, function: function, line: line)
}

/// Debug log function.
/// - parameter message: Message to log.
public func logDebug(_ message: @autoclosure () -> String,
              file: StaticString = #file,
              function: StaticString = #function,
              line: UInt = #line) {
    
    logMessage(message(), flag: .debug, file: file, function: function, line: line)
}

/// Verbose log function. This level of logs usually is excessive but may be helpful in some cases.
/// - parameter message: Message to log.
public func logVerbose(_ message: @autoclosure () -> String,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {
    
    logMessage(message(), flag: .verbose, file: file, function: function, line: line)
}

/// Message log function.
/// - parameter message: Message to log.
/// - parameter flag: Log level, e.g. `.error`, `.debug`, ...
public func logMessage(_ message: @autoclosure () -> String,
                flag: DDLogFlag,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {
    
    LoggersManager.shared.logMessage(message(), flag: flag, file: file, function: function, line: line)
}
