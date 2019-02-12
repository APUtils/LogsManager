//
//  LoggersManager.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation

import CocoaLumberjack


/// Central point for all application logs.
/// You can easily change how logs will be displayed or processed here.
public final class LoggersManager {
    
    // ******************************* MARK: - Singleton
    
    public static var shared: LoggersManager = LoggersManager()
    
    // ******************************* MARK: - Private Properties
    
    private var logComponents: [LogComponent] = []
    private var messageLoggers: [BaseTextLogger] = []
    private var errorLoggers: [ErrorLogger] = []
    
    // ******************************* MARK: - Initialization and Setup
    
    public init() {
        setup()
    }
    
    private func setup() {
        
    }
    
    deinit {
        // Remove loggers
        messageLoggers.forEach { DDLog.remove($0) }
    }
    
    // ******************************* MARK: - Public Methods
    
    /// Registers log component for detection
    public func registerLogComponent(_ logComponent: LogComponent) {
        guard !logComponents.contains(logComponent) else {
            print("Log component '\(logComponent)' was already added")
            return
        }
        
        logComponents.append(logComponent)
    }
    
    /// Uregisters log component from detection
    public func unregisterLogComponent(_ logComponent: LogComponent) {
        guard logComponents.contains(logComponent) else {
            print("Log component '\(logComponent)' is not added")
            return
        }
        
        logComponents.remove(logComponent)
    }
    
    /// Adds text logger
    public func addTextLogger(_ logger: BaseTextLogger) {
        DDLog.add(logger, with: logger.logLevel)
    }
    
    /// Removes text logger
    public func removeTextLogger(_ logger: BaseTextLogger) {
        DDLog.remove(logger)
    }
    
    /// Adds error logger
    public func addErrorLogger(_ logger: ErrorLogger) {
        errorLoggers.append(logger)
    }
    
    /// Log message function.
    /// - parameter logComponents: Components this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
    /// - parameter data: Data to attach to log message.
    /// - parameter message: Message to log.
    /// - parameter flag: Log level, e.g. `.error`, `.debug`, ...
    public func logMessage(logComponents: [LogComponent]? = nil, message: @autoclosure () -> String, flag: DDLogFlag, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let logComponents = logComponents ?? detectLogComponent(file: file, function: function)
        _DDLogMessage(message,
                      level: dynamicLogLevel,
                      flag: flag,
                      context: 0,
                      file: file,
                      function: function,
                      line: line,
                      tag: logComponents,
                      asynchronous: false,
                      ddlog: DDLog.sharedInstance)
    }
    
    /// Log error function.
    /// - parameter logComponents: Components this log belongs to, e.g. `.network`, `.keychain`, ... . Autodetect if `nil`.
    /// - parameter reason: Reason of error.
    /// - parameter error: Error that occured.
    /// - parameter data: Data to attach to error.
    /// - parameter flag: Log level, e.g. `.error`, `.debug`, ...
    public func logError(logComponents: [LogComponent]? = nil, reason: @autoclosure () -> String, error: Any?, data: [String: Any?]?, flag: DDLogFlag, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let normalizedData = normalizeData(data)
        errorLoggers.forEach { $0.log(reason: reason, error: error, data: normalizedData, file: file, function: function, line: line) }
        
        let errorMessage: String
        let reason = reason()
        if let normalizedData = normalizedData {
            if let error = error {
                errorMessage = "\(reason)\n\(error)\n\(normalizedData)"
            } else {
                errorMessage = "\(reason)\n\(normalizedData)"
            }
        } else {
            errorMessage = reason
        }
        
        logMessage(logComponents: logComponents, message: errorMessage, flag: .error, file: file, function: function, line: line)
    }
    
    // ******************************* MARK: - Private Methods
    
    private func detectLogComponent(file: StaticString, function: StaticString) -> [LogComponent] {
        var components: [LogComponent] = logComponents
            .filter { $0.isLogForThisComponent(file, function) }
        
        if components.isEmpty {
            components.append(.unspecified)
        }
        
        return components
    }
    
    private func normalizeData(_ data: [String: Any?]?) -> [String: String]? {
        guard let data = data else { return nil }
        
        var normalizedData = [String: String]()
        for (key, value) in data {
            let description: String
            if let value = value as? Data {
                description = value.asString
            } else if let value = value {
                description = String(describing: value)
            } else {
                description = "nil"
            }
            
            normalizedData[key] = description
        }
        
        return normalizedData
    }
}
