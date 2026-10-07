//
//  DDAbstractLogger+QoS.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 10/7/26.
//  Copyright © 2026 Anton Plebanovich. All rights reserved.
//

#if SPM
import LogsManagerObjc
#endif
import CocoaLumberjack
import Foundation

extension DDAbstractLogger {
    
    /// Raises the logger queue QoS to `userInitiated` when logs are synchronous.
    ///
    /// A synchronous log holds the global logging queue until every logger has processed the message,
    /// and a logger queue without a QoS processes it at the QoS of the thread that logged.
    /// For a `background` thread that is `background` work the system may leave unscheduled for seconds,
    /// and nothing boosts it when the main thread logs next and waits for the same queue.
    ///
    /// Must be called right after `super.init()`.
    func raiseLoggerQueueQoSIfNeeded() {
        guard !LoggersManager.logMessagesAsync else { return }
        _replaceLoggerQueue(qos: QOS_CLASS_USER_INITIATED)
    }
}
