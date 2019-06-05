//
//  FileLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 6/5/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import CocoaLumberjack

public final class FileLogger: DDFileLogger, BaseTextLogger {
    
    // ******************************* MARK: - BaseTextLogger
    
    public let logLevel: DDLogLevel
    public var mode: LoggerMode
    
    public required init(mode: LoggerMode, logLevel: DDLogLevel, logsDirectory: String? = nil) {
        self.logLevel = logLevel
        self.mode = mode
        
        let fileManager: DDLogFileManagerDefault
        if let logsDirectory = logsDirectory {
            fileManager = DDLogFileManagerDefault(logsDirectory: logsDirectory)
        } else {
            let defaultLogsDirectory = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .last!
                .appendingPathComponent("LogsManager", isDirectory: true)
                .path
            
            var isDirectory: ObjCBool = true
            if !FileManager.default.fileExists(atPath: defaultLogsDirectory, isDirectory: &isDirectory) {
                do {
                    try FileManager.default.createDirectory(atPath: defaultLogsDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Unable to create default logs directory: \(error)")
                }
            }
            
            fileManager = DDLogFileManagerDefault(logsDirectory: defaultLogsDirectory)
        }
        
        super.init(logFileManager: fileManager, completionQueue: nil)
        
        setup()
    }
    
    private func setup() {
        logFormatter = BaseFileLogFormatter(mode: mode)
    }
    
    // ******************************* MARK: - DDFileLogger Overrides
    
    override public func log(message logMessage: DDLogMessage) {
        guard shouldLog(message: logMessage) else { return }
        super.log(message: logMessage)
    }
}
