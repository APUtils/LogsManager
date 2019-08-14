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
        return tag as? Parameters
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
        var data: [String: Any?]?
        var error: Any?
        var logComponents: [LogComponent]?
    }
}

public extension DDLogMessage.Parameters {
    
    /// Stringified data
    var normalizedData: [String: String]? {
        return normalizeData(data)
    }
    
    /// Stringified error
    var normalizedError: String? {
        return normalizeError(error)
    }
    
    /// Method to normalize error.
    private func normalizeError(_ error: Any?) -> String? {
        guard let error = error else { return nil }
        return String(describing: error)
    }
    
    /// Method to normalize data.
    private func normalizeData(_ data: [String: Any?]?) -> [String: String]? {
        guard let data = data else { return nil }
        
        var normalizedData = [String: String]()
        for (key, value) in data {
            let description: String
            if let value = value as? Data {
                description = value.asString
            } else if let value = value {
                description = String(describing: value)
            } else {
                description = "nil"
            }
            
            normalizedData[key] = description
        }
        
        return normalizedData
    }
}
