//
//  Int.swift
//  InstabugInterview
//
//  Created by Mohamed Ziad on 30/03/2022.
//

import Foundation
extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}
