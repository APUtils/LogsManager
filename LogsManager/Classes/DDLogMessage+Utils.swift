//
//  DDLogMessage+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation
import CocoaLumberjack


public extension DDLogMessage {
    var logComponents: [LogComponent]? {
        return tag as? [LogComponent]
    }
    
    var flagLogString: String {
        return "\(flag) Log"
    }
}
