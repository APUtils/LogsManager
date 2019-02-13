//
//  ErrorLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 2/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation


/// Error logger protocol
public protocol ErrorLogger {
    func log(reason: @autoclosure () -> String, error: Any?, data: [String: String]?, file: StaticString, function: StaticString, line: UInt)
}
