//
//  DDLogFlag+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 1/2/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

import CocoaLumberjack

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
        
        let description = flagComponents.joined(separator: ", ")
        
        return description
    }
}
