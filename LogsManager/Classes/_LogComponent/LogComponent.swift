//
//  LogComponent.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 2/12/19.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation


public struct LogComponent {
    
    // ******************************* MARK: - Types
    
    public typealias LogComponentDetection = (_ file: String, _ function: String) -> Bool
    
    // ******************************* MARK: - Public Properties
    
    /// Log component name. Used instead of `logName` if it's nil. Must be unique.
    public let name: String
    
    /// Log component name that will be used in logs. `name` will be used if it's `nil`.
    public let logName: String?
    
    /// Whether log is for this component?
    public let isLogForThisComponent: LogComponentDetection
    
    /// Text that will be displayed in logs forthis component.
    /// Uses `logName` if it isn't `nil`. Otherwise uses `name`.
    /// If result is an empty string - component will be logged but not somehow indicated in logs.
    public var logText: String {
        return logName ?? name
    }
    
    /// Initialize log component with `name` and `logName`.
    /// - parameters:
    ///   - name: Log component name. Used instead of `logName` if it's nil.
    ///   - logName: Log component name that will be used in logs. By default `nil` and `name` is used in logs. If empty component part will be omitted in logs.
    ///   - isLogForThisComponent: Whether log is for this component?
    public init(name: String, logName: String? = nil, isLogForThisComponent: @escaping LogComponentDetection) {
        self.name = name
        self.logName = logName
        self.isLogForThisComponent = isLogForThisComponent
    }
}

// ******************************* MARK: - Equatable

extension LogComponent: Equatable {
    public static func == (lhs: LogComponent, rhs: LogComponent) -> Bool {
        return lhs.name == rhs.name
    }
}

// ******************************* MARK: - Predefined Log Components

public extension LogComponent {
    /// Log component that is returned in a case when log component wasn't detected.
    static var unspecified: LogComponent {
        return LogComponent(name: "Unspecified", logName: "", isLogForThisComponent: { _, _ in false })
    }
    
    /// Log component for logs in `deinit` method.
    static var deinitialize: LogComponent {
        return LogComponent(name: "Deinitialize", logName: "D", isLogForThisComponent: { _, function in
            return String(function) == "deinit"
        })
    }
}
