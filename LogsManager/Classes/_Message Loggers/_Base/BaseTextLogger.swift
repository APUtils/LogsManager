//
//  BaseTextLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation

/// Logger mode.
public enum LoggerMode {
    /// Log everything
    case all
    
    /// Log specific components only
    case specificComponents([LogComponent])
    
    /// Log everything except ignored components
    case ignoreComponents([LogComponent])
}

/// Minimal requirements for logger
public protocol BaseTextLogger: DDLogger {
    /// Level of logs that logger logs
    var logLevel: DDLogLevel { get }
    
    /// Mode in which logger works.
    var mode: LoggerMode { get }
}

// ******************************* MARK: - Default Implementation

public extension BaseTextLogger {
    func shouldLog(message: DDLogMessage) -> Bool {
        if let messageLogComponents = message.logComponents {
            switch mode {
            case .all: return true
            case .specificComponents(let logComponents): return logComponents.hasIntersection(with: messageLogComponents)
            case .ignoreComponents(let logComponents): return messageLogComponents.removing(contentsOf: logComponents).hasElements
            }
        } else {
            // Log do not belong to any component or logger doesn't have components filter. Pass it.
            return true
        }
    }
}
