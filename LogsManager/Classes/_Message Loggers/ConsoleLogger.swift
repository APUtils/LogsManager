//
//  ConsoleLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

#if SPM
import LogsManagerObjc
#endif
import CocoaLumberjack
import Foundation

/// Logger that logs to console.
///
/// - note: There won't be migration to the `DDOSLogger` since it produces too verbose output like
/// `2021-04-06 15:37:46.099278+0300 LogsManager_Example[29318:2294160] ...`. That just pollutes the console.
open class ConsoleLogger: _DDTTYLogger, BaseLogger {
    
    // ******************************* MARK: - BaseLogger
    
    public let logLevel: DDLogLevel
    public var mode: LoggerMode
    public let newLinesSeparation: Bool
    public let dateFormatter: DateFormatter?
    
    public required init(mode: LoggerMode,
                         logLevel: DDLogLevel,
                         newLinesSeparation: Bool,
                         dateFormatter: DateFormatter? = BaseLogFormatter.dateFormatter) {
        
        self.logLevel = logLevel
        self.mode = mode
        self.newLinesSeparation = newLinesSeparation
        self.dateFormatter = dateFormatter
        
        super.init()
        
        setup()
    }
    
    private func setup() {
        logFormatter = BaseLogFormatter(mode: mode, dateFormatter: dateFormatter)
    }
    
    // ******************************* MARK: - DDLogger Overrides
    
    override public func log(message logMessage: DDLogMessage) {
        guard shouldLog(message: logMessage) else { return }
        
        if newLinesSeparation { super.log(message: BaseLogFormatter.emptyLineMessage) }
        super.log(message: logMessage)
        if newLinesSeparation { super.log(message: BaseLogFormatter.emptyLineMessage) }
    }
}
