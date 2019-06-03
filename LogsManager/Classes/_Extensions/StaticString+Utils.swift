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
   static func getFileName(from file: StaticString) -> String {
        let filePath = String(describing: file)
        var fileName = URL(fileURLWithPath: filePath).lastPathComponent
        fileName = fileName.replacingOccurrences(of: ".swift", with: "")
        
        return fileName
    }
}

extension StaticString: Equatable {
    public static func == (lhs: StaticString, rhs: StaticString) -> Bool {
        if lhs.hasPointerRepresentation, rhs.hasPointerRepresentation, lhs.utf8Start == rhs.utf8Start {
            return true
        } else if lhs.utf8CodeUnitCount != rhs.utf8CodeUnitCount {
            return false
        } else {
            return String(lhs) == String(rhs)
        }
    }
}

extension StaticString: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(self))
    }
}
