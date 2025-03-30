//
//  Collection+.swift
//  SwiftRouting
//
//  Created by Elie Melki on 26/03/2025.
//

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    
}

extension Array {
    @discardableResult
    mutating func safeRemove(_ range: Range<Int>) -> Array {
        let lowerBound = Swift.max(range.lowerBound,0)
        let higherBound = Swift.min(range.upperBound,self.count)
        let safeRange = lowerBound..<higherBound
        
        let values = Array(self[safeRange])
        self.removeSubrange(range)
        return values
    }
  
}

extension Array where Element : Equatable {
    
    mutating func safeRemoveStarting(_ object: Element) {
        guard let index = firstIndex(of: object) else {
            return
        }
        self.safeRemove(index..<self.count)
    }
}

extension Array where Element : AnyObject {
    
    mutating func safeRemoveStartingReference(_ object: Element)  {
        let index = firstIndex {
            $0 === object
        }
        
        guard let index = index else {
            return
        }
        self.safeRemove(index..<self.count)
    }
}
