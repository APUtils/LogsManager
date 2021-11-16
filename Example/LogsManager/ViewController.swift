//
//  ViewController.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 02/11/2019.
//  Copyright (c) 2019 Anton Plebanovich. All rights reserved.
//

import APExtensions
import LogsManager
import RoutableLogger
import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var routedLog: String?
        RoutableLogger.logInfoHandler = { message, _, _, _ in routedLog = message() }
        RoutableLogger.logInfo("Log routed")
        print(routedLog!)
        
        logDebug("Message filter check")
        logError("Error filter check")
        
        LoggersManager.shared.registerLogComponent(.timeFormat)
        LoggersManager.shared.registerLogComponent(.vc)
        LoggersManager.shared.registerLogComponent(.didAppear)
        LoggersManager.shared.registerLogComponent(.buttonTap)
        LoggersManager.shared.registerLogComponent(.deinitialize)
        LoggersManager.shared.registerLogComponent(.initialize)
        
        let allLogger = ConsoleLogger(mode: .all, logLevel: .verbose, newLinesSeparation: false)
        LoggersManager.shared.addLogger(allLogger)
        
        LoggersManager.shared.addFileLogger()
        LoggersManager.shared.removeFileLogger()
        LoggersManager.shared.addFileLogger()
        
        let logger = ConsoleLogger(mode: .specificComponents([.vc]), logLevel: .verbose, newLinesSeparation: true)
        LoggersManager.shared.addLogger(logger)
        logDebug("Test1")
        
        LoggersManager.shared.removeLogger(logger)
        logDebug("Test2")
        
        LoggersManager.shared.addLogger(logger)
        logDebug("Test3")
        
        LoggersManager.shared.unregisterLogComponent(.vc)
        logDebug("Test4")
        
        logDebug("Test5")
        
        logImportantErrorOnce()
        logImportantErrorOnce()
        
        logData("""
{
  "glossary": {
    "title": "example glossary",
    "GlossDiv": {
      "title": "S",
      "GlossList": {
        "GlossEntry": {
          "ID": "SGML",
          "SortAs": "SGML",
          "GlossTerm": "Standard Generalized Markup Language",
          "Acronym": "SGML",
          "Abbrev": "ISO 8879:1986",
          "GlossDef": {
            "para": "A meta-markup language, used to create markup languages such as DocBook.",
            "GlossSeeAlso": [
              "GML",
              "XML"
            ]
          },
          "GlossSee": "markup"
        }
      }
    }
  }
}
""")
        
        _ = InitTester()
        _ = InitTester(with: 2)
        
        LoggersManager.shared.registerLogComponent(.allLog2)
        logDebug("Test6")
        
        LoggersManager.shared.registerLogComponent(.allLog3)
        LoggersManager.shared.registerLogComponent(.allLog4)
        logDebug("Test7")
        
        let all3Logger = ConsoleLogger(mode: .specificComponents([.allLog3]), logLevel: .warning, newLinesSeparation: false)
        LoggersManager.shared.addLogger(all3Logger)
        logInfo("Test 8")
        logWarning("Test 9")
        
        logError("Test 9.1", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]))
        logError("Test 9.2", data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
        logError("Test 10", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]), data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
        
        let allAlertLogger = AlertLogger(mode: .all, logLevel: .error)
        LoggersManager.shared.addLogger(allAlertLogger)
        
        let buttonTapLogger = AlertLogger(mode: .specificComponentsAndLevels([(.buttonTap, .info)]), logLevel: .info)
        LoggersManager.shared.addLogger(buttonTapLogger)
        
        if #available(iOS 10.0, *) {
            let allNotificationsLogger = NotificationLogger(mode: .muteComponents([.didAppear]), logLevel: .debug)
            LoggersManager.shared.addLogger(allNotificationsLogger)
        }
        
        logError("Test 11", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]), data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert], completionHandler: { _, _ in })
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in
            g.sharedApplication.startBackgroundTaskIfNeeded()
            
            g.asyncMain(2) {
                logError("BG test", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]), data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
                g.sharedApplication.startBackgroundTaskIfNeeded()
            }
        }
        
        testSameLine()
        testSameLine()
        
        LoggersManager.shared.pause()
        logWarning("This one should be paused")
        LoggersManager.shared.resume()
        logWarning("And this one should not")
        
        let customDateFormatter = DateFormatter()
        customDateFormatter.timeStyle = .full
        customDateFormatter.dateStyle = .full
        
        LoggersManager.shared.addLogger(
            ConsoleLogger(mode: .specificComponents([.timeFormat]),
                          logLevel: .all,
                          newLinesSeparation: true,
                          dateFormatter: customDateFormatter)
        )
        logData("This one should have different time format", logComponents: [.timeFormat])
        
        logError("Non-error class error check", error: self)
        logError("Non-JSON user info check", error: NSError(domain: "Non-JSON", code: -100, userInfo: ["vc": self]))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logDebug("viewDidAppear called")
    }
    
    private func testSameLine() {
        logDebug("Test same line")
    }
    
    // ******************************* MARK: - Action
    
    @IBAction private func onTap(_ sender: Any) {
        logInfo("Button tap")
    }
    
    // ******************************* MARK: - Private Methods
    
    private func logImportantErrorOnce() {
        logErrorOnce("logImportantErrorOnce")
    }
}

extension LogComponent {
    static let vc = LogComponent(name: "ViewController", logName: "VC") { _, fileName, _ in
        fileName == "ViewController"
    }
    
    static let didAppear = LogComponent(name: "Did Appear", logName: "viewDidAppear") { _, _, function in
        function.hasPrefix("viewDidAppear")
    }
    
    static let buttonTap = LogComponent(name: "Button Tap", logName: "BT") { _, fileName, function in
        fileName == "ViewController" && function == "onTap(_:)"
    }
    
    static let allLog2 = LogComponent(name: "All2", logName: "", isLogForThisComponent: { _, _, _ in true })
    static let allLog3 = LogComponent(name: "All3", logName: "3", isLogForThisComponent: { _, _, _ in true })
    static let allLog4 = LogComponent(name: "All4", logName: "4", isLogForThisComponent: { _, _, _ in true })
    static let timeFormat = LogComponent(name: "Time Format", logName: "TF", isLogForThisComponent: { _, _, _ in false })
}

// ******************************* MARK: - UNUserNotificationCenterDelegate

@available(iOS 10.0, *)
extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

private struct InitTester {
    init() {
        logInfo("Initialized InitTester")
    }
    
    init(with param: Int) {
        logInfo("Initialized InitTester with param: \(param)")
    }
}
