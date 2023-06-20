//
//  DDLogFlag+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 1/2/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

import CocoaLumberjack

// ******************************* MARK: - Data Log

public extension DDLogFlag {
    
    /// Trace log level.
    static let trace = DDLogFlag(rawValue: 1 << 5)
    
    /// Data log level.
    static let data = DDLogFlag(rawValue: 1 << 6)
}

// ******************************* MARK: - CustomStringConvertible

extension DDLogFlag: CustomStringConvertible {
    public var description: String {
        var flagComponents: [String] = []
        if contains(.error) {
            flagComponents.append("Error")
        }
        if contains(.warning) {
            flagComponents.append("Warning")
        }
        if contains(.info) {
            flagComponents.append("Info")
        }
        if contains(.debug) {
            flagComponents.append("Debug")
        }
        if contains(.verbose) {
            flagComponents.append("Verbose")
        }
        if contains(.trace) {
            flagComponents.append("Trace")
        }
        if contains(.data) {
            flagComponents.append("Data")
        }
        
        let description = flagComponents.joined(separator: ", ")
        
        return description
    }
}
