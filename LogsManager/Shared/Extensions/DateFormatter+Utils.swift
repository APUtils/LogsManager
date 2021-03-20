//
//  DateFormatter+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let `default`: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd HH:mm:ss.SSS"
        
        return dateFormatter
    }()
}
