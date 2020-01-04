//
//  ConsoleLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation


/// Logger that logs to console.
open class ConsoleLogger: DDTTYLogger, BaseLogger {
    
    // ******************************* MARK: - BaseLogger
    
    public let logLevel: DDLogLevel
    public var mode: LoggerMode
    public let newLinesSeparation: Bool
    
    public required init(mode: LoggerMode, logLevel: DDLogLevel, newLinesSeparation: Bool) {
        self.logLevel = logLevel
        self.mode = mode
        self.newLinesSeparation = newLinesSeparation
        
        super.init()
        
        setup()
    }
    
    private func setup() {
        logFormatter = BaseLogFormatter(mode: mode)
    }
    
    // ******************************* MARK: - DDLogger Overrides
    
    override public func log(message logMessage: DDLogMessage) {
        guard shouldLog(message: logMessage) else { return }
        
        if newLinesSeparation { super.log(message: BaseLogFormatter.emptyLineMessage) }
        super.log(message: logMessage)
        if newLinesSeparation { super.log(message: BaseLogFormatter.emptyLineMessage) }
    }
}
