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
    
    private let mode: LoggerMode
    
    // ******************************* MARK: - Initialization and Setup
    
    public required init(mode: LoggerMode) {
        self.mode = mode
    }
    
    // ******************************* MARK: - DDLogFormatter
    
    open func format(message logMessage: DDLogMessage) -> String? {
        let logComponents: [LogComponent]
        if let messageLogComponents = logMessage.logComponents {
            switch mode {
            // Use all components from message
            case .all: logComponents = messageLogComponents
                
            // Search for intersections for clearer logs
            case .specificComponents(let _logComponents): logComponents = messageLogComponents.intersection(with: _logComponents)
                
            // Filter ignored components from message components
            case .ignoreComponents(let _logComponents): logComponents = messageLogComponents.removing(contentsOf: _logComponents)
            }
        } else {
            // Message doesn't have any components.
            logComponents = []
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
