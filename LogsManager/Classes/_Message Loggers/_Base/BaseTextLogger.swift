//
//  BaseTextLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation

import CocoaLumberjack


/// Minimal requirements for logger
public protocol BaseTextLogger: DDLogger {
    /// Level of logs that logger logs
    var logLevel: DDLogLevel { get }
    
    /// Components that logger logs. If `nil` logger will log all logs.
    var logComponents: [LogComponent]? { get }
}

// ******************************* MARK: - Default Implementation

public extension BaseTextLogger {
    public func shouldLog(message: DDLogMessage) -> Bool {
        if let messageLogComponents = message.logComponents, let logComponents = logComponents {
            return logComponents.hasIntersection(with: messageLogComponents)
        } else {
            // Log do not belong to any component or logger doesn't have components filter. Pass it.
            return true
        }
    }
}
