//
//  Data+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 2/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

// ******************************* MARK: - As

extension Data {
    /// Try to convert data to ASCII string
    var asciiString: String? {
        return String(data: self, encoding: String.Encoding.ascii)
    }
    
    /// Try to convert data to UTF8 string
    var utf8String: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
    
    /// Get HEX string from data. Can be used for sending APNS token to backend.
    var hexString: String {
        return reduce("", {$0 + String(format: "%02X", $1)})
    }
    
    /// String representation for data.
    /// Try to decode as UTF8 string at first.
    /// Try to decode as ASCII string at second.
    /// Uses hex representation if data can not be represented as UTF8 or ASCII string.
    var asString: String {
        return utf8String ?? asciiString ?? hexString
    }
}
