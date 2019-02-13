//
//  StaticString+Utils.swift
//  Pods
//
//  Created by Anton Plebanovich on 2/12/19.
//  
//

import Foundation


public extension StaticString {
    /// Helper method to get filename from `file` parameter that is a file path.
    /// - parameters:
    ///   - file: File path that is passed through `#file` compile directrive as default parameter.
   public static func getFileName(from file: StaticString) -> String {
        let filePath = String(describing: file)
        var fileName = URL(fileURLWithPath: filePath).lastPathComponent
        fileName = fileName.replacingOccurrences(of: ".swift", with: "")
        
        return fileName
    }
}
