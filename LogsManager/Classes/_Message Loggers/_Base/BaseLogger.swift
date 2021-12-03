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
    
    /// Log everything except ignored components.
    /// If message has several log components and not all of them are ignored - message will be logged with left components.
    case ignoreComponents([LogComponent])
    
    /// Log everything that doesn't have listed components.
    /// Even if log message have any other log components it won't be logged.
    case muteComponents([LogComponent])
    
    /// Log everything that doesn't have listed components.
    /// Even if log message have any other log components it won't be logged.
    /// However, if log level is the same or above specified the log passes.
    case muteComponentsBelowLevel([LogComponentAndLevel])
    
    static func getIntersection(forLogComponentsAndLevels logComponentsAndLevels: [LogComponentAndLevel], with message: DDLogMessage) -> [LogComponent] {
        guard let messageLogComponents = message.logComponents else { return logComponentsAndLevels.map { $0.0 } }
        
        // Get intersection pairs and check if their log level is enough to log this message.
        // Off = 0, Error = 1, ... Verbose.rawValue > Debug.rawValue
        return logComponentsAndLevels
            .filter { logComponent, level in messageLogComponents.contains(logComponent) && level.rawValue >= message.level.rawValue }
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
                
            case .muteComponents(let logComponents):
                return !logComponents.hasIntersection(with: messageLogComponents)
                
            case .muteComponentsBelowLevel(let muteLogComponentsAndLevels):
                let messageLogLevel = message.level
                let mutedLogComponents = muteLogComponentsAndLevels.compactMap { muteLogComponent, muteLevel -> LogComponent? in
                    // Verbose = 31, error = 1
                    if messageLogLevel.rawValue <= muteLevel.rawValue {
                        return nil
                    } else {
                        // Mute log components that are below defined level
                        return muteLogComponent
                    }
                }
                
                return !mutedLogComponents.hasIntersection(with: messageLogComponents)
            }
        } else {
            // Log do not belong to any component or logger doesn't have components filter. Pass it.
            return true
        }
    }
}
