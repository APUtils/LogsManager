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
    
    /// Returns intersection array.
    func intersection(with array: [Element]) -> [Element] {
        return filter { !array.contains($0) }
    }
    
    /// Helper method to remove all objects that are equal to passed one.
    mutating func remove(_ element: Element) {
        while let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
    
    /// Helper method to remove all objects that are equal to those contained in `contentsOf` array.
    mutating func remove(contentsOf: [Element]) {
        contentsOf.forEach { remove($0) }
    }
    
    /// Helper method to remove all objects that are equal to those contained in `contentsOf` array.
    func removing(contentsOf: [Element]) -> [Element] {
        var filtered = self
        contentsOf.forEach { filtered.remove($0) }
        return filtered
    }
}
