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
    
    /// You may set it to `nil` to remove time component from logs or assign your custom formatter.
    /// This will affect all loggers that use default date formatter.
    public static var dateFormatter: DateFormatter? = .default
    
    /// Message that if passed won't be formatted and will be added to logs as an empty line
    public static let emptyLineMessage: DDLogMessage = DDLogMessage(message: "",
                                                                    level: .all,
                                                                    flag: .data,
                                                                    context: 0,
                                                                    file: "",
                                                                    function: nil,
                                                                    line: 0,
                                                                    tag: nil,
                                                                    options: [],
                                                                    timestamp: nil)
    
    // ******************************* MARK: - Private Properties
    
    private let mode: LoggerMode
    private let oneLine: Bool
    private let dateFormatter: DateFormatter?
    
    // ******************************* MARK: - Initialization and Setup
    
    public required init(mode: LoggerMode, 
                         oneLine: Bool,
                         dateFormatter: DateFormatter? = BaseLogFormatter.dateFormatter) {
        
        self.mode = mode
        self.oneLine = oneLine
        self.dateFormatter = dateFormatter
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
            case .specificComponents(let specificLogComponents):
                logComponents = messageLogComponents.intersection(with: specificLogComponents)
                
            // Search for intersection and filter out components with not enough log level
            case .specificComponentsAndLevels(let logComponentsAndLevels):
                logComponents = LoggerMode.getIntersection(forLogComponentsAndLevels: logComponentsAndLevels, with: logMessage)
                
                // Search for intersections for clearer logs
            case .specificAndMutedComponents(let specificLogComponents, _):
                logComponents = messageLogComponents.intersection(with: specificLogComponents)
                
            case .specificAndMutedComponentsAndLevels(let specificLogComponentsAndLevels, _):
                logComponents = LoggerMode.getIntersection(forLogComponentsAndLevels: specificLogComponentsAndLevels,
                                                           with: logMessage)
                
            // Filter ignored components from message components
            case .ignoreComponents(let ignoreLogComponents):
                logComponents = messageLogComponents.removing(contentsOf: ignoreLogComponents)
                
            // Just return the same components because we have no intersection
            case .muteComponents:
                logComponents = messageLogComponents
                
            case .muteComponentsBelowLevel:
                logComponents = messageLogComponents
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
        
        let normalizedError = logMessage.parameters?.normalizedError
        let normalizedData = logMessage.parameters?.normalizedData
        let errorString = Utils.normalizedErrorString(normalizedError, normalizedData: normalizedData, oneLine: oneLine)
        
        let dataString = Utils.normalizedDataString(normalizedData, oneLine: oneLine)
        let timeString = dateFormatter?.string(from: logMessage.timestamp) ?? ""
        let prefixString = messagePrefix(flag: logMessage.flag)
        let messageString = Utils.normalizedMessage(logMessage.message, normalizedData: normalizedData, normalizedError: normalizedError, oneLine: oneLine)
        
        let logString = "\(timeString)\(componentsString) | \(prefixString)\(messageString)\(errorString)\(dataString)"
        
        return logString
    }
}
