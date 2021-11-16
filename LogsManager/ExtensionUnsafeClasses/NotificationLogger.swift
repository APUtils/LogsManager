//
//  NotificationLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation
import UserNotifications
#if !COCOAPODS
import LogsManager
#endif
import CocoaLumberjack


/// Logger that fires local notifications. Assure that notification permissions were granted for alert presentation.
@available(iOS 10.0, macOS 10.14, tvOS 10.0, *)
open class NotificationLogger: BaseAbstractTextLogger {
    
    // ******************************* MARK: - BaseAbstractTextLogger Overrides
    
    override public func process(message logMessage: DDLogMessage, formattedMessage: String) {
        let content = UNMutableNotificationContent()
        content.title = logMessage.flagLogString
        content.body = formattedMessage
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Can't schedule local notification: \(error)")
            }
        }
    }
}
