//
//  String+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 2/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

public extension String {
    /// Helper method to get filename from `file` parameter that is a file path.
    /// - parameters:
    ///   - filePath: File path that is passed through `#file` compile directrive as default parameter.
    static func getFileName(filePath: String) -> String {
        guard let lastPathComponent = filePath.components(separatedBy: "/").last else { return "" }
        
        var components = lastPathComponent.components(separatedBy: ".")
        if components.count == 1 {
            return lastPathComponent
        } else {
            components.removeLast()
            return components.joined(separator: ".")
        }
    }
}
