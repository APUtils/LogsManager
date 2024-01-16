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
        return "Error Type=\(type(of: error)) \(String(describing: error))"
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
    static func normalizeData(_ data: [AnyHashable: Any?]?, skipDataNormalizationKeyPrefix: String?) -> [String: String]? {
        guard let data = data else { return nil }
        
        var normalizedData = [String: String]()
        for (key, value) in data {
            let keyString = "\(key)"
            if let skipDataNormalizationKeyPrefix, keyString.hasPrefix(skipDataNormalizationKeyPrefix) { continue }
            
            let description: String
            if let value = value as? Data {
                description = value.asString
            } else if let value = value {
                description = String(describing: value)
            } else {
                description = "nil"
            }
            
            normalizedData[keyString] = description
        }
        
        return normalizedData
    }
    
    static func normalizedMessage(_ message: String, normalizedData: [String: String]?, normalizedError: String?, oneLine: Bool) -> String {
        return message
            .oneLineIfNeeded(oneLine)
            .middlePrefixIfNeeded(!oneLine, isLast: normalizedData?.isEmpty != false && normalizedError?.isEmpty != false)
    }
    
    static func normalizedDataString(_ data: [String: String]?, oneLine: Bool) -> String {
        guard let data, !data.isEmpty else { return "" }
        
        let lastIndex = data.count - 1
        let dataString = data
            .sorted { $0.key <= $1.key }
            .enumerated()
            .map { (index, tuple) in
                let key = tuple.key
                let value = tuple.value
                let isLast = index == lastIndex
                let formattedValue = value
                    .oneLineIfNeeded(oneLine)
                    .middlePrefixIfNeeded(!oneLine, isLast: isLast)
                
                let prefix = getLinePrefix(oneLine: oneLine, isLast: isLast)
                return "\(prefix)\(key): \(formattedValue)"
            }
            .joined()
        
        return dataString
            .oneLineIfNeeded(oneLine)
    }
    
    static func normalizedErrorString(_ error: String?, normalizedData: [String: String]?, oneLine: Bool) -> String {
        guard let error, !error.isEmpty else { return "" }
        
        let isLast = normalizedData?.isEmpty != false
        let formattedError = error
            .oneLineIfNeeded(oneLine)
            .middlePrefixIfNeeded(!oneLine, isLast: isLast)
        
        return "\(getLinePrefix(oneLine: oneLine, isLast: isLast))error: \(formattedError)"
    }
    
    @inlinable static func getLinePrefix(oneLine: Bool, isLast: Bool) -> String {
        if oneLine {
            return Constants.oneLineSeparator
        } else {
            return isLast ? Constants.newLineLastPrefix : Constants.newLinePrefix
        }
    }
}

// ******************************* MARK: - Constants

extension Utils { enum Constants {} }
extension Utils.Constants {
    static let oneLineSeparator = " | "
    static let newLinePrefixLeftWhitespace = "  "
    static let newLinePrefixRightWhitespace = " "
    
    // https://www.w3.org/TR/xml-entity-names/025.html
    static let newLinePrefix = "\n\(newLinePrefixLeftWhitespace)├\(newLinePrefixRightWhitespace)"
    static let newLineContinuePrefix = "\n\(newLinePrefixLeftWhitespace)│\(newLinePrefixRightWhitespace)"
    static let newLineLastPrefix = "\n\(newLinePrefixLeftWhitespace)└\(newLinePrefixRightWhitespace)"
    static let newLineContinueLastPrefix = "\n\(newLinePrefixLeftWhitespace) \(newLinePrefixRightWhitespace)"
}

// ******************************* MARK: - Private Extensions

extension String {
    
    func oneLineIfNeeded(_ oneLine: Bool) -> String {
        if oneLine {
            return replacingOccurrences(of: "\n", with: Utils.Constants.oneLineSeparator)
                .replacingOccurrences(of: "\r", with: Utils.Constants.oneLineSeparator)
            
        } else {
            return self
        }
    }
    
    func middlePrefixIfNeeded(_ middle: Bool, isLast: Bool) -> String {
        if middle {
            if isLast {
                return replacingOccurrences(of: "\n", with: Utils.Constants.newLineContinueLastPrefix)
                    .replacingOccurrences(of: "\r", with: Utils.Constants.newLineContinueLastPrefix)
                
            } else {
                return replacingOccurrences(of: "\n", with: Utils.Constants.newLineContinuePrefix)
                    .replacingOccurrences(of: "\r", with: Utils.Constants.newLineContinuePrefix)
            }
            
        } else {
            return self
        }
    }
}
