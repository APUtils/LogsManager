//
//  AlertLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation
import CocoaLumberjack


/// Logger that logs with alerts.
public final class AlertLogger: BaseAbstractLogger {
    
    // ******************************* MARK: - BaseAbstractLogger Overrides
    
    override public func process(message logMessage: DDLogMessage, formattedMessage: String) {
        g.showErrorAlert(title: logMessage.flagLogString, message: formattedMessage)
    }
}
