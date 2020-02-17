//
//  BaseFileLogFormatter.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 6/5/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation

open class BaseFileLogFormatter: BaseLogFormatter {
    open override func messagePrefix(flag: DDLogFlag) -> String {
        
        // Add log level prefixes so we can easily filter messages using stream commands
        if flag == .error {
            return "E> "
        } else if flag == .warning {
            return "W> "
        } else if flag == .info {
            return "I> "
        } else if flag == .debug {
            return "D> "
        } else if flag == .verbose {
            return "V> "
        } else if flag == .data {
            return "Data> "
        } else {
            return ""
        }
    }
    
    open override func format(message logMessage: DDLogMessage) -> String? {
        var formattedMessage = super.format(message: logMessage)
        
        // Keep message in one line so we can easily work with those messages using stream commands
        formattedMessage = formattedMessage?.replacingOccurrences(of: "\n", with: " | ")
        formattedMessage = formattedMessage?.replacingOccurrences(of: "\r", with: " | ")
        
        return formattedMessage
    }
}
