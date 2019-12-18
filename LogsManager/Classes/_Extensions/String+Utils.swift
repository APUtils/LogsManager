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
        var fileName = URL(fileURLWithPath: filePath).lastPathComponent
        fileName = fileName
            .replacingOccurrences(of: ".swift", with: "")
            .replacingOccurrences(of: ".m", with: "")
            .replacingOccurrences(of: ".mm", with: "")
        
        return fileName
    }
}
