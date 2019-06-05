//
//  BaseTextLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation

import CocoaLumberjack


public enum LoggerMode {
    case all
    case specificComponents([LogComponent])
    case ignoreComponents([LogComponent])
}


/// Minimal requirements for logger
public protocol BaseTextLogger: DDLogger {
    /// Level of logs that logger logs
    var logLevel: DDLogLevel { get }
    
    /// Components that logger logs. If `nil` logger will log all logs.
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
