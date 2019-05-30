//
//  ViewController.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 02/11/2019.
//  Copyright (c) 2019 Anton Plebanovich. All rights reserved.
//

import UIKit

import APExtensions
import LogsManager
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vcComponent = LogComponent(name: "ViewController", logName: "VC") { file, _ in
            let fileName = StaticString.getFileName(from: file)
            return fileName == "ViewController"
        }
        LoggersManager.shared.registerLogComponent(vcComponent)
        
        let didAppearComponent = LogComponent(name: "Did Appear", logName: "viewDidAppear") { _, function in
            return String(function).hasPrefix("viewDidAppear")
        }
        LoggersManager.shared.registerLogComponent(didAppearComponent)
        
        let logger = ConsoleLogger(logComponents: [vcComponent], logLevel: .verbose, newLinesSeparation: false)
        LoggersManager.shared.addTextLogger(logger)
        logDebug(message: "Test1")
        
        LoggersManager.shared.removeTextLogger(logger)
        logDebug(message: "Test2")
        
        LoggersManager.shared.addTextLogger(logger)
        logDebug(message: "Test3")
        
        LoggersManager.shared.unregisterLogComponent(vcComponent)
        logDebug(message: "Test4")
        
        let allLogger = ConsoleLogger(logComponents: nil, logLevel: .verbose, newLinesSeparation: false)
        LoggersManager.shared.addTextLogger(allLogger)
        logDebug(message: "Test5")
        
        let allLogComponent2 = LogComponent(name: "All2", logName: "", isLogForThisComponent: { _, _ in true })
        LoggersManager.shared.registerLogComponent(allLogComponent2)
        logDebug(message: "Test6")
        
        let allLogComponent3 = LogComponent(name: "All3", logName: "3", isLogForThisComponent: { _, _ in true })
        let allLogComponent4 = LogComponent(name: "All4", logName: "4", isLogForThisComponent: { _, _ in true })
        LoggersManager.shared.registerLogComponent(allLogComponent3)
        LoggersManager.shared.registerLogComponent(allLogComponent4)
        logDebug(message: "Test7")
        
        let all3Logger = ConsoleLogger(logComponents: [allLogComponent3], logLevel: .warning, newLinesSeparation: false)
        LoggersManager.shared.addTextLogger(all3Logger)
        logInfo(message: "Test 8")
        logWarning(message: "Test 9")
        logError(reason: "Test 10", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]), data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
        
        let allAlertLogger = AlertLogger(logComponents: nil, logLevel: .error)
        LoggersManager.shared.addTextLogger(allAlertLogger)
        
        if #available(iOS 10.0, *) {
            let allNotificationsLogger = NotificationLogger(logComponents: nil, logLevel: .error)
            LoggersManager.shared.addTextLogger(allNotificationsLogger)
        }
        
        logError(reason: "Test 11", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]), data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert], completionHandler: { _, _ in })
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in
            g.sharedApplication.startBackgroundTaskIfNeeded()
            
            g.asyncMain(2) {
                logError(reason: "BG test", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]), data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
                g.sharedApplication.startBackgroundTaskIfNeeded()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logDebug(message: "viewDidAppear called")
    }
}
