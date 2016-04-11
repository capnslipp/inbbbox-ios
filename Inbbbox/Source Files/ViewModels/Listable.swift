//
//  Listable.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol Listable {
    
    associatedtype Type
    
    var count: Int { get }
    
    init(_ items: [Type])
    subscript(index: Int) -> Type { get }
    
    mutating func add(item: Type, atIndex index: Int)
    mutating func remove(index: Int) -> Type
    
    func itemize(closure: (index: Int, item: Type) -> ())
}


// MARK: List

class List<T> : Listable {
    
    var count: Int { return items.count }
    
    var items: [T]
    
    required init(_ items: [T]) {
        self.items = items
    }
    
    subscript(index: Int) -> T {
        return items[index]
    }
    
    func add(item: T, atIndex index: Int) {
        items.insert(item, atIndex: index)
    }
    
    func remove(index: Int) -> T {
        return items.removeAtIndex(index)
    }
    
    func itemize(closure: (index: Int, item: T) -> ()) {
        for (index, item) in items.enumerate() {
            closure(index: index, item: item)
        }
    }
}


// MARK: Section

class Section<T: Equatable> : List<T>, Equatable {
    
    var title: String?
    
    required init(_ items: [T]) {
        super.init(items)
    }
}

func ==<T: Equatable>(lhs: Section<T>, rhs: Section<T>) -> Bool {
    return lhs.title == rhs.title && lhs.items == rhs.items
}
