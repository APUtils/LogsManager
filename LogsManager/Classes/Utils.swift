//
//  Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 2/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation


final class Globals {
    
    // ******************************* MARK: - Typealiases
    
    /// Closure that takes Void and returns Void.
    typealias SimpleClosure = () -> Void
    
    // ******************************* MARK: - Top View Controller
    
    /// Current top most view controller
    var topViewController: UIViewController? {
        return topViewController()
    }
    
    /// Returns top view controller from `base` controller.
    /// - note: In case you are using custom container controllers in your application this method won't be able to process them.
    /// - parameters:
    ///   - base: Base controller from which to start. If not specified or nil then application delegate window's rootViewController will be used.
    ///   - shouldCheckPresented: Should it check for presented controllers?
    func topViewController(base: UIViewController? = nil, shouldCheckPresented: Bool = true) -> UIViewController? {
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
    
    /// Returns top most view controller that handles status bar style.
    /// This property might be more accurate than `g_topViewController` if custom container view controllers configured properly to return their top most controllers for status bar appearance.
    var statusBarStyleTopViewController: UIViewController? {
        var currentVc = topViewController
        while let newTopVc = currentVc?.childForStatusBarStyle {
            currentVc = topViewController(base: newTopVc)
        }
        
        return currentVc
    }
    
    // ******************************* MARK: - Perform
    
    /// Executes a closure if already in main or dispatch asyn in main. Uses GCD.
    /// - parameters:
    ///   - closure: the closure to be executed
    func performInMain(_ closure: @escaping SimpleClosure) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async { closure() }
        }
    }
    
    // ******************************* MARK: - Alert
    
    /// Shows error alert with title, message, action title, cancel title and handler
    /// - parameter title: Alert title. Default is `nil` - no title.
    /// - parameter message: Alert message. Default is `nil` - no message.
    /// - parameter actionTitle: Action button title. Default is `Dismiss`.
    /// - parameter style: Action button style. Default is `.cancel`.
    /// - parameter cancelTitle: Cancel button title. Default is `nil` - no cancel button.
    /// - parameter handler: Action button click closure. Default is `nil` - no action.
    public func showErrorAlert(title: String? = nil, message: String? = nil, actionTitle: String = "Dismiss", style: UIAlertAction.Style = .cancel, cancelTitle: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        
        performInMain {
            let alertVC = AlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: actionTitle, style: style, handler: handler))
            if let cancelTitle = cancelTitle {
                alertVC.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: nil))
            }
            
            alertVC.present(animated: true)
        }
    }
}

var g: Globals = Globals()
