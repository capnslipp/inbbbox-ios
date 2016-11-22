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

    mutating func add(_ item: Type, atIndex index: Int)
    mutating func remove(_ index: Int) -> Type

    func itemize(_ closure: (_ index: Int, _ item: Type) -> ())
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

    func add(_ item: T, atIndex index: Int) {
        items.insert(item, at: index)
    }

    func remove(_ index: Int) -> T {
        return items.remove(at: index)
    }

    func itemize(_ closure: (_ index: Int, _ item: T) -> ()) {
        for (index, item) in items.enumerated() {
            closure(index, item)
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
