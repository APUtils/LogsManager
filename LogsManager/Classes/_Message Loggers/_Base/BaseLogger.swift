//
//  BaseLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation

/// Logger mode.
public enum LoggerMode {
    
    public typealias LogComponentAndLevel = (LogComponent, DDLogLevel)
    
    /// Log everything
    case all
    
    /// Log specific components only
    case specificComponents([LogComponent])
    
    /// Log specific components with specific log levels only
    case specificComponentsAndLevels([LogComponentAndLevel])
    
    /// Log everything except ignored components
    case ignoreComponents([LogComponent])
    
    static func getIntersection(forLogComponentsAndLevels logComponentsAndLevels: [LogComponentAndLevel], with message: DDLogMessage) -> [LogComponent] {
        guard let messageLogComponents = message.logComponents else { return logComponentsAndLevels.map { $0.0 } }
        
        // Get intersection pairs and check if their log level is enough to log this message.
        // Off = 0, Error = 1, ... Verbose.rawValue > Debug.rawValue
        return logComponentsAndLevels
            .filter { messageLogComponents.contains($0.0) && $0.1.rawValue >= message.level.rawValue }
            .map { $0.0 }
    }
}

/// Minimal requirements for a logger
public protocol BaseLogger: DDLogger {
    /// Level of logs that logger logs
    var logLevel: DDLogLevel { get }
    
    /// Mode in which logger works.
    var mode: LoggerMode { get }
}

// ******************************* MARK: - Default Implementation

public extension BaseLogger {
    func shouldLog(message: DDLogMessage) -> Bool {
        if let messageLogComponents = message.logComponents {
            switch mode {
            case .all:
                return true
                
            case .specificComponents(let logComponents):
                return logComponents.hasIntersection(with: messageLogComponents)
                
            case .specificComponentsAndLevels(let logComponentsAndLevels):
                return LoggerMode.getIntersection(forLogComponentsAndLevels: logComponentsAndLevels, with: message).hasElements
                
            case .ignoreComponents(let logComponents):
                return messageLogComponents.removing(contentsOf: logComponents).hasElements
            }
        } else {
            // Log do not belong to any component or logger doesn't have components filter. Pass it.
            return true
        }
    }
}
