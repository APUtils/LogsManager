//
//  BaseAbstractTextLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation

import CocoaLumberjack


/// Abstract base class inherited from DDAbstractLogger that represents text logger.
/// Override process(message:) in child classes
open class BaseAbstractTextLogger: DDAbstractLogger, BaseLogger {
    
    // ******************************* MARK: - BaseLogger
    
    public let logLevel: DDLogLevel
    public let mode: LoggerMode
    
    required public init(mode: LoggerMode, logLevel: DDLogLevel) {
        self.mode = mode
        self.logLevel = logLevel
        
        super.init()
        
        setup()
    }
    
    private func setup() {
        logFormatter = BaseLogFormatter(mode: mode)
    }
    
    // ******************************* MARK: - DDLogger Overrides
    
    override open func log(message logMessage: DDLogMessage) {
        guard shouldLog(message: logMessage) else { return }
        
        var formattedMessage: String
        if let logFormatter = value(forKey: "_logFormatter") as? DDLogFormatter {
            formattedMessage = logFormatter.format(message: logMessage) ?? logMessage.message
        } else {
            formattedMessage = logMessage.message
        }
        
        if let normalizedError = logMessage.parameters?.normalizedError { formattedMessage.append("\n\(normalizedError)") }
        if let normalizedData = logMessage.parameters?.normalizedData { formattedMessage.append("\n\(normalizedData)") }
        
        process(message: logMessage, formattedMessage: formattedMessage)
    }
    
    // ******************************* MARK: - Open Methods
    
    /// Abstract method that should be overridden. Message validation already done. You shouldn't call super in your implementation.
    open func process(message logMessage: DDLogMessage, formattedMessage: String) {
        assertionFailure("Should be overrided in child class")
    }
}
