//
//  CrashlyticsLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation
import FirebaseCrashlytics

/// Crashlytics logger.
open class CrashlyticsLogger: BaseAbstractTextLogger {
    
    // ******************************* MARK: - BaseAbstractTextLogger
    
    open override func process(message logMessage: DDLogMessage, formattedMessage: String) {
        if logMessage.flag == .error {
            // Record errors
            let parameters = logMessage.parameters
            recordError(logMessage.message,
                        errorDescription: parameters?.normalizedError,
                        data: parameters?.normalizedData,
                        file: logMessage.file,
                        line: logMessage.line)
        }
        
        // Also add to logs so it'll be visible in subsequent error logs.
        var escapedMessage = formattedMessage
        
        // Fabric cut everything after new line symbol.
        escapedMessage = escapedMessage
            .replacingOccurrences(of: "\t", with: " ")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
            // Remove excessive spaces
            .split(separator: " ")
            .joined(separator: " ")
            // Assure we won't crash on unexpected '%' symbols
            .replacingOccurrences(of: "%", with: "%%")
        
        Crashlytics.crashlytics().log(escapedMessage)
    }
    
    // ******************************* MARK: - Private Methods
    
    open func recordError(_ message: String,
                          errorDescription: String?,
                          data: [String: String]?,
                          file: String,
                          line: UInt) {
        
        // Values to always attach to report
        var userInfo = data ?? [:]
        
        // Prevent conflicts between custom values and reserved values
        userInfo = userInfo.mapKeys { "_\($0)" }
        
        // Error line information
        userInfo[NSLocalizedDescriptionKey] = "line \(line)"
        
        // Error description
        userInfo["error_description"] = errorDescription
        
        let moduleName = String.getFileName(filePath: String(file))
        let errorName = "\(moduleName): \(message)"
        let formattedError = NSError(domain: errorName, code: -1, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: formattedError)
    }
}

private extension Dictionary {
    
    /// Returns a new dictionary containing the values of this dictionary with the
    /// keys transformed by the given closure.
    ///
    /// - Parameter transform: A closure that transforms a key.
    /// - Returns: A dictionary containing transformed keys and values.
    func mapKeys(_ transform: (Dictionary.Key) throws -> Dictionary.Key) rethrows -> [Dictionary.Key: Dictionary.Value] {
        return try reduce(into: [:]) { result, keyAndValue in
            result[try transform(keyAndValue.key)] = keyAndValue.value
        }
    }
}
