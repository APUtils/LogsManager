//
//  CrashlyticsBaseErrorLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 2/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation


/// Helper class to format Crashlytics error. Can be used for convenience.
open class CrashlyticsBaseErrorLogger: ErrorLogger {
    
    open func log(reason: @autoclosure () -> String,
                           error: Any?,
                           data: [String: String]?,
                           file: StaticString = #file,
                           function: StaticString = #function,
                           line: UInt = #line) {
        
        // Values to always attach to report
        var data = data ?? [:]
        if let error = error {
            data["errorDescription"] = String(describing: error)
        }
        
        let moduleName = StaticString.getFileName(from: file)
        let reasonString = reason()
        let errorName = "\(moduleName): \(reasonString)"
        let errorDescription = "line \(line)"
        
        var userInfo = [String: Any]()
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        if !data.isEmpty { userInfo["error_data"] = data }
        
        let formattedError = NSError(domain: errorName, code: -1, userInfo: userInfo)
        
        recordFormattedError(formattedError: formattedError)
    }
    
    open func recordFormattedError(formattedError: Error) {
        assertionFailure("Override and call `Crashlytics.sharedInstance().recordError(formattedError)` here")
    }
}
