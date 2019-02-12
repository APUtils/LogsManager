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
    public var logComponents: [LogComponent]? {
        return tag as? [LogComponent]
    }
    
    public var flagLogString: String {
        return "\(flag) Log"
    }
}
