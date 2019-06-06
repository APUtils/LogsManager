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
    
    /// Message that if passed won't be formatted and will be add to logs as an empty line
    public static let emptyLineMessage: DDLogMessage = DDLogMessage(message: "",
                                                                    level: .all,
                                                                    flag: .verbose,
                                                                    context: 0,
                                                                    file: "",
                                                                    function: nil,
                                                                    line: 0,
                                                                    tag: nil,
                                                                    options: [],
                                                                    timestamp: nil)
    
    // ******************************* MARK: - Private Properties
    
    private let mode: LoggerMode
    
    // ******************************* MARK: - Initialization and Setup
    
    public required init(mode: LoggerMode) {
        self.mode = mode
    }
    
    // ******************************* MARK: - Open Functions
    
    /// Prefix to append to message depending on `flag`.
    open func messagePrefix(flag: DDLogFlag) -> String {
        if flag == .error {
            return "[ ** ERROR ** ] "
        } else if flag == .warning {
            return "[ * WARNING * ] "
        } else {
            return ""
        }
    }
    
    // ******************************* MARK: - DDLogFormatter
    
    open func format(message logMessage: DDLogMessage) -> String? {
        if logMessage === BaseLogFormatter.emptyLineMessage {
            return " "
        }
        
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
        
        let prefixString = messagePrefix(flag: logMessage.flag)
        let timeString = BaseLogFormatter.dateFormatter?.string(from: logMessage.timestamp) ?? ""
        let logString = "\(timeString)\(componentsString) | \(prefixString)\(logMessage.message)"
        
        return logString
    }
}
