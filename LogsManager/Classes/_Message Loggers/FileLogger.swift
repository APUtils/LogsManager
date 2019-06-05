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
    public let newLinesSeparation: Bool
    
    public required init(mode: LoggerMode, logLevel: DDLogLevel, newLinesSeparation: Bool, logsDirectory: String? = nil) {
        self.logLevel = logLevel
        self.mode = mode
        self.newLinesSeparation = newLinesSeparation
        
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
        logFormatter = BaseLogFormatter(mode: mode)
    }
    
    // ******************************* MARK: - DDFileLogger Overrides
    
    override public func log(message logMessage: DDLogMessage) {
        guard shouldLog(message: logMessage) else { return }
        
        if newLinesSeparation { super.log(message: BaseLogFormatter.emptyLineMessage) }
        super.log(message: logMessage)
        if newLinesSeparation { super.log(message: BaseLogFormatter.emptyLineMessage) }
    }
}
