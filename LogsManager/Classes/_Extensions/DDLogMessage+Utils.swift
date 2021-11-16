//
//  DDLogMessage+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation

public extension DDLogMessage {
    var parameters: Parameters? {
        return representedObject as? Parameters
    }
    
    var data: [String: Any?]? {
        return parameters?.data
    }
    
    var error: Any? {
        return parameters?.error
    }
    
    var logComponents: [LogComponent]? {
        return parameters?.logComponents
    }
    
    var flagLogString: String {
        return "\(flag) Log"
    }
}

// ******************************* MARK: - Parameters

public extension DDLogMessage {
    struct Parameters {
        public var data: [String: Any?]?
        public var error: Any?
        public var logComponents: [LogComponent]?
        public var normalizedData: [String: String]?
        public var normalizedError: String?
    }
}

public extension DDLogMessage.Parameters {
    
    init(data: [String: Any?]?, error: Any?, logComponents: [LogComponent]?) {
        self.data = data
        self.error = error
        self.logComponents = logComponents
        
        normalizedError = Utils.normalizeError(error)
        normalizedData = Utils.normalizeData(data)
        
        // Add localized description to data if it differs from the error
        if let localizedDescription = Utils.localizedDescription(error),
           localizedDescription.hasElements,
           localizedDescription != normalizedError {
            
            normalizedData = normalizedData ?? [:]
            normalizedData?["localizedDescription"] = localizedDescription
        }
        
        // Add debug description to data if it differs from the error
        if let debugDescription = Utils.debugDescription(error),
           debugDescription.hasElements,
           debugDescription != normalizedError {
            
            normalizedData = normalizedData ?? [:]
            normalizedData?["debugDescription"] = debugDescription
        }
        
        if let error = error as? Error, let userInfo = error._userInfo {
            let options: JSONSerialization.WritingOptions
            if #available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOSApplicationExtension 6.0, *) {
                options = [.sortedKeys, .fragmentsAllowed, .withoutEscapingSlashes]
            } else if #available(iOS 11.0, tvOS 11.0, macOS 10.13, watchOSApplicationExtension 4.0, *) {
                options = [.sortedKeys, .fragmentsAllowed]
            } else {
                options = [.fragmentsAllowed]
            }
            
            normalizedData = normalizedData ?? [:]
            
            if JSONSerialization.isValidJSONObject(userInfo),
                let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: options) {
                
                normalizedData?["errorUserInfoJSON"] = jsonData.asString
                
            } else {
                normalizedData?["errorUserInfo"] = "\(userInfo)"
            }
        }
    }
}
