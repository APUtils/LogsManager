//
//  CrashLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation

/// Logger that logs with crashes. May be usefull for warnings or errors catching during debug or UI testing.
open class CrashLogger: BaseAbstractTextLogger {
    
    // ******************************* MARK: - BaseAbstractTextLogger Overrides
    
    override public func process(message logMessage: DDLogMessage, formattedMessage: String) {
        fatalError(formattedMessage)
    }
}
