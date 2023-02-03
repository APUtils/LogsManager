//
//  ViewController.swift
//  PackageExample
//
//  Created by Anton Plebanovich on 3.02.23.
//

import LogsManager
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let consoleLogger = ConsoleLogger(mode: .all, logLevel: .all, newLinesSeparation: false)
        LoggersManager.shared.addLogger(consoleLogger)
        
        LoggersManager.shared.addFileLogger()
        
        logWarning("viewDidLoad")
    }


}

