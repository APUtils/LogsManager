//
//  ConsoleLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation
import CocoaLumberjack


/// Logger that logs to console.
public final class ConsoleLogger: DDTTYLogger, BaseTextLogger {
    
    // ******************************* MARK: - BaseTextLogger
    
    public let logLevel: DDLogLevel
    public var logComponents: [LogComponent]?
    public let newLinesSeparation: Bool
    
    public required init(logComponents: [LogComponent]?, logLevel: DDLogLevel, newLinesSeparation: Bool) {
        self.logLevel = logLevel
        self.logComponents = logComponents
        self.newLinesSeparation = newLinesSeparation
        
        super.init()
        
        setup()
    }
    
    private func setup() {
        logFormatter = BaseLogFormatter(logComponents: logComponents)
    }
    
    // ******************************* MARK: - DDLogger Overrides
    
    override public func log(message logMessage: DDLogMessage) {
        guard shouldLog(message: logMessage) else { return }
        
        if newLinesSeparation { print() }
        super.log(message: logMessage)
        if newLinesSeparation { print() }
    }
}
