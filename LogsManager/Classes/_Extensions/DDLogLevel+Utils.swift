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
        if flag.contains(.verbose) {
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