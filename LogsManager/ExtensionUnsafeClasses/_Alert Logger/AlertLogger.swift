//
//  AlertLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation
#if !COCOAPODS
import LogsManager
#endif
import UIKit

/// Logger that logs with alerts.
open class AlertLogger: BaseAbstractTextLogger {
    
    // ******************************* MARK: - BaseAbstractTextLogger Overrides
    
    override public func process(message logMessage: DDLogMessage, formattedMessage: String) {
        showErrorAlert(title: logMessage.flagLogString, message: formattedMessage)
    }
    
    // ******************************* MARK: - Alert
    
    /// Shows error alert with title, message, action title, cancel title and handler
    /// - parameter title: Alert title. Default is `nil` - no title.
    /// - parameter message: Alert message. Default is `nil` - no message.
    /// - parameter actionTitle: Action button title. Default is `Dismiss`.
    /// - parameter style: Action button style. Default is `.cancel`.
    /// - parameter cancelTitle: Cancel button title. Default is `nil` - no cancel button.
    /// - parameter handler: Action button click closure. Default is `nil` - no action.
    private func showErrorAlert(title: String? = nil, message: String? = nil, actionTitle: String = "Dismiss", style: UIAlertAction.Style = .cancel, cancelTitle: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        
        performInMain {
            let alertVC = AlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: actionTitle, style: style, handler: handler))
            if let cancelTitle = cancelTitle {
                alertVC.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: nil))
            }
            
            alertVC.present(animated: true)
        }
    }
    
    // ******************************* MARK: - Typealiases
    
    /// Closure that takes Void and returns Void.
    private typealias SimpleClosure = () -> Void
    
    // ******************************* MARK: - Perform
    
    /// Executes a closure if already in main or dispatch asyn in main. Uses GCD.
    /// - parameters:
    ///   - closure: the closure to be executed
    private func performInMain(_ closure: @escaping SimpleClosure) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async { closure() }
        }
    }
}

// ******************************* MARK: - AlertController

private final class AlertController: UIAlertController {
    
    // ******************************* MARK: - Types
    
    enum PresentationStyle {
        /// Present in separate window
        case window
        
        /// Present in key window from top presented controller
        case topController
    }
    
    // ******************************* MARK: - Classes Properties
    
    static var presentationStyle: PresentationStyle = .window
    
    // ******************************* MARK: - Private Properties
    
    private lazy var alertWindow: UIWindow? = {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.windowLevel = .alert
        alertWindow.rootViewController = AppearanceCaptureViewController()
        
        return alertWindow
    }()
    
    // ******************************* MARK: - UIViewController Methods
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if AlertController.presentationStyle == .window {
            alertWindow?.isHidden = true
            alertWindow = nil
        }
    }
    
    // ******************************* MARK: - Public Methods
    
    func present(animated: Bool, completion: (() -> Void)? = nil) {
        if let popover = popoverPresentationController {
            // Prevent crash by targeting bottom of the screen
            if popover.sourceView == nil && popover.sourceRect == .zero {
                if AlertController.presentationStyle == .window, let alertWindow = alertWindow {
                    popover.sourceView = alertWindow
                    popover.sourceRect = CGRect(x: alertWindow.bounds.size.width / 2, y: alertWindow.bounds.size.height, width: 0, height: 0)
                } else if let view = Globals.topViewController?.view {
                    popover.sourceView = view
                    popover.sourceRect = CGRect(x: view.bounds.size.width / 2, y: view.bounds.size.height, width: 0, height: 0)
                } else {
                    print("AlertController: can not get sourceView and sourceRect for presentation")
                    return
                }
            }
        }
        
        switch AlertController.presentationStyle {
        case .window:
            self.alertWindow?.makeKeyAndVisible()
            self.alertWindow?.rootViewController?.present(self, animated: animated, completion: completion)
            
        case .topController:
            Globals.topViewController?.present(self, animated: animated, completion: completion)
        }
    }
}

/// Can be used in overlaying windows to capture underlaying appearance and prevent it change.
/// Appearance captured on initialization.
private final class AppearanceCaptureViewController: UIViewController {
    private var customPreferredStatusBarStyle = UIStatusBarStyle.lightContent
    private var customPrefersStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return customPrefersStatusBarHidden
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return customPreferredStatusBarStyle
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        onInitSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        onInitSetup()
    }
    
    private func onInitSetup() {
        let topVc = statusBarStyleTopViewController
        
        customPrefersStatusBarHidden = topVc?.prefersStatusBarHidden ?? false
        
        if (Bundle.main.object(forInfoDictionaryKey: "UIViewControllerBasedStatusBarAppearance") as! Bool?) ?? true {
            customPreferredStatusBarStyle = topVc?.preferredStatusBarStyle ?? .default
        } else {
            if let barStyle = topVc?.navigationController?.navigationBar.barStyle {
                customPreferredStatusBarStyle = barStyle == .black ? .lightContent : .default
            }
        }
    }
    
    /// Returns top most view controller that handles status bar style.
    /// This property might be more accurate than `g_topViewController` if custom container view controllers configured properly to return their top most controllers for status bar appearance.
    private var statusBarStyleTopViewController: UIViewController? {
        var currentVc = Globals.topViewController
        while let newTopVc = currentVc?.childForStatusBarStyle {
            currentVc = Globals.topViewController(base: newTopVc)
        }
        
        return currentVc
    }
}

// ******************************* MARK: - Globals

private enum Globals {
    
    // ******************************* MARK: - Top View Controller
    
    /// Current top most view controller
    static var topViewController: UIViewController? {
        return topViewController()
    }
    
    /// Returns top view controller from `base` controller.
    /// - note: In case you are using custom container controllers in your application this method won't be able to process them.
    /// - parameters:
    ///   - base: Base controller from which to start. If not specified or nil then application delegate window's rootViewController will be used.
    ///   - shouldCheckPresented: Should it check for presented controllers?
    static func topViewController(base: UIViewController? = nil, shouldCheckPresented: Bool = true) -> UIViewController? {
        let base = base ?? UIApplication.shared.delegate?.window??.rootViewController
        
        if let navigationVc = base as? UINavigationController {
            return topViewController(base: navigationVc.topViewController, shouldCheckPresented: shouldCheckPresented)
        }
        
        if let tabBarVc = base as? UITabBarController {
            if let selected = tabBarVc.selectedViewController {
                return topViewController(base: selected, shouldCheckPresented: shouldCheckPresented)
            }
        }
        
        if shouldCheckPresented, let presented = base?.presentedViewController {
            return topViewController(base: presented, shouldCheckPresented: shouldCheckPresented)
        }
        
        return base
    }
}
