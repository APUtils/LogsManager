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
/// - parameter reason: Error reason.
public func logError(reason: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    logError(reason: reason(), error: nil, data: nil, file: file, function: function, line: line)
}

/// Error log function. Also send error to crash tracking systems.
/// - parameter reason: Error reason.
/// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
public func logError(reason: @autoclosure () -> String,
              data: [String: Any?]?,
              file: StaticString = #file,
              function: StaticString = #function,
              line: UInt = #line) {
    logError(reason: reason(), error: nil, data: data, file: file, function: function, line: line)
}

/// Error log function. Also send error to crash tracking systems.
/// - parameter reason: Error reason.
/// - parameter error: Error that happened.
public func logError(reason: @autoclosure () -> String, error: Any?, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    logError(reason: reason(), error: error, data: nil, file: file, function: function, line: line)
}

/// Error log function. Also send error to crash tracking systems.
/// - parameter logComponent: Component this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
/// - parameter reason: Error reason.
/// - parameter error: Error that happened.
/// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
public func logError(reason: @autoclosure () -> String,
              error: Any?,
              data: [String: Any?]?,
              file: StaticString = #file,
              function: StaticString = #function,
              line: UInt = #line) {
    
    logError(reason: reason(), error: error, data: data, flag: .error, file: file, function: function, line: line)
}

/// Error log function.
/// - parameter logComponent: Component this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
/// - parameter reason: Message to log.
/// - parameter flag: Log level, e.g. `.error`, `.debug`, ...
/// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
public func logError(reason: @autoclosure () -> String,
              error: Any?,
              data: [String: Any?]?,
              flag: DDLogFlag,
              file: StaticString = #file,
              function: StaticString = #function,
              line: UInt = #line) {
    
    LoggersManager.shared.logError(reason: reason(), error: error, data: data, flag: flag, file: file, function: function, line: line)
}

/// Warning log function.
/// - parameter logComponent: Component this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
/// - parameter message: Message to log.
public func logWarning(message: @autoclosure () -> String,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {
    
    logMessage(message: message(), flag: .warning, file: file, function: function, line: line)
}

/// Info log function.
/// - parameter logComponent: Component this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
/// - parameter message: Message to log.
public func logInfo(message: @autoclosure () -> String,
             file: StaticString = #file,
             function: StaticString = #function,
             line: UInt = #line) {
    
    logMessage(message: message(), flag: .info, file: file, function: function, line: line)
}

/// Debug log function.
/// - parameter message: Message to log.
public func logDebug(message: @autoclosure () -> String,
              file: StaticString = #file,
              function: StaticString = #function,
              line: UInt = #line) {
    
    logMessage(message: message(), flag: .debug, file: file, function: function, line: line)
}

/// Verbose log function. This level of logs usually is excessive but may be helpful in some cases.
/// - parameter logComponent: Component this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
/// - parameter message: Message to log.
public func logVerbose(message: @autoclosure () -> String,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {
    
    logMessage(message: message(), flag: .verbose, file: file, function: function, line: line)
}

/// Message log function.
/// - parameter logComponent: Component this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
/// - parameter message: Message to log.
/// - parameter flag: Log level, e.g. `.error`, `.debug`, ...
public func logMessage(message: @autoclosure () -> String,
                flag: DDLogFlag,
                file: StaticString = #file,
                function: StaticString = #function,
                line: UInt = #line) {
    
    LoggersManager.shared.logMessage(message: message(), flag: flag, file: file, function: function, line: line)
}
