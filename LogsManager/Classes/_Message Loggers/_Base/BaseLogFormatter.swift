//
//  BaseLogFormatter.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/23/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation

import CocoaLumberjack


open class BaseLogFormatter: NSObject, DDLogFormatter {
    
    // ******************************* MARK: - Class Properties
    
    public static var dateFormatter: DateFormatter? = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd HH:mm:ss.SSS"
        
        return dateFormatter
    }()
    
    // ******************************* MARK: - Private Properties
    
    private let logComponents: [LogComponent]?
    
    // ******************************* MARK: - Initialization and Setup
    
    public required init(logComponents: [LogComponent]?) {
        self.logComponents = logComponents
    }
    
    // ******************************* MARK: - DDLogFormatter
    
    open func format(message logMessage: DDLogMessage) -> String? {
        let logComponents: [LogComponent]
        if let _logComponents = self.logComponents {
            // Search for intersections for clearer logs
            logComponents = logMessage.logComponents?
                .filter { messageLogComponent in
                    _logComponents.contains { $0.name == messageLogComponent.name }
                } ?? []
            
        } else {
            // Use all components from message
            logComponents = logMessage.logComponents ?? []
        }
        
        let logComponentLogTexts: [String] = logComponents
            .map { $0.logText }
            .filter { !$0.isEmpty }
        
        let componentsString: String
        if logComponentLogTexts.isEmpty {
            componentsString = ""
        } else {
            componentsString = " | \(logComponentLogTexts.joined(separator: " | "))"
        }
        
        let prefixString: String
        if logMessage.flag == .error {
            prefixString = "[ ** ERROR ** ] "
        } else if logMessage.flag == .warning {
            prefixString = "[ * WARNING * ] "
        } else {
            prefixString = ""
        }
        
        let timeString = BaseLogFormatter.dateFormatter?.string(from: logMessage.timestamp) ?? ""
        let logString = "\(timeString)\(componentsString) | \(prefixString)\(logMessage.message)"
        
        return logString
    }
}
