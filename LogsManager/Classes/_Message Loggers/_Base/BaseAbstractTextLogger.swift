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
    public let dateFormatter: DateFormatter?
    
    public init(mode: LoggerMode,
                         logLevel: DDLogLevel,
                         dateFormatter: DateFormatter? = BaseLogFormatter.dateFormatter) {
        
        self.mode = mode
        self.logLevel = logLevel
        self.dateFormatter = dateFormatter
        
        super.init()
        
        setup()
    }
    
    private func setup() {
        logFormatter = BaseLogFormatter(mode: mode, dateFormatter: dateFormatter)
    }
    
    // ******************************* MARK: - DDLogger Overrides
    
    override open func log(message logMessage: DDLogMessage) {
        guard shouldLog(message: logMessage) else { return }
        
        let formattedMessage: String
        if let logFormatter = value(forKey: "_logFormatter") as? DDLogFormatter {
            formattedMessage = logFormatter.format(message: logMessage) ?? logMessage.message
        } else {
            formattedMessage = logMessage.message
        }
        
        process(message: logMessage, formattedMessage: formattedMessage)
    }
    
    // ******************************* MARK: - Open Methods
    
    /// Abstract method that should be overridden. Message validation already done. You shouldn't call super in your implementation.
    open func process(message logMessage: DDLogMessage, formattedMessage: String) {
        assertionFailure("Should be overrided in child class")
    }
}
