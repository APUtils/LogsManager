//
//  Array+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 2/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation


extension Array where Element: Equatable {
    /// Returns whether array has at least one common element with passed array.
    func hasIntersection(with array: [Element]) -> Bool {
        return contains { array.contains($0) }
    }
    
    /// Helper method to remove all objects that are equal to passed one.
    public mutating func remove(_ element: Element) {
        while let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
    
    /// Helper method to remove all objects that are equal to those contained in `contentsOf` array.
    public mutating func remove(contentsOf: [Element]) {
        contentsOf.forEach { remove($0) }
    }
}
