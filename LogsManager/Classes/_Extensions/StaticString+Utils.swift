//
//  StaticString+Utils.swift
//  Pods
//
//  Created by Anton Plebanovich on 2/12/19.
//  
//

import Foundation

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
