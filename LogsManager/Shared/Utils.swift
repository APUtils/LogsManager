//
//  Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation

final class Utils {
    
    /// Method to normalize error.
    static func normalizeError(_ error: Any?) -> String? {
        guard let error = error else { return nil }
        return String(describing: error)
    }
    
    static func localizedDescription(_ error: Any?) -> String? {
        guard let error = error as? Error else { return nil }
        return error.localizedDescription
    }
    
    static func debugDescription(_ error: Any?) -> String? {
        guard let error = error, let error = error as? CustomDebugStringConvertible else { return nil }
        return error.debugDescription
    }
    
    /// Method to normalize data.
    static func normalizeData(_ data: [String: Any?]?) -> [String: String]? {
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
