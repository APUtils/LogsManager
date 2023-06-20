//
//  DDLogLevel+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 8/27/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation

extension DDLogLevel {
    init(flag: DDLogFlag) {
        if flag.contains(.data) {
            self = .data
        } else if flag.contains(.trace) {
            self = .trace
        } else if flag.contains(.verbose) {
            self = .verbose
        } else if flag.contains(.debug) {
            self = .debug
        } else if flag.contains(.info) {
            self = .info
        } else if flag.contains(.warning) {
            self = .warning
        } else if flag.contains(.error) {
            self = .error
        } else {
            self = .off
        }
    }
}

// ******************************* MARK: - Data Log

public extension DDLogLevel {
    static let data: DDLogLevel = DDLogLevel(rawValue: DDLogLevel.trace.rawValue | DDLogFlag.data.rawValue)!
    static let trace: DDLogLevel = DDLogLevel(rawValue: DDLogLevel.verbose.rawValue | DDLogFlag.trace.rawValue)!
}
