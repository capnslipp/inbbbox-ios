//
//  GroupedListViewModel.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ExtendedIndexPathOperatable {
    func indexPathsForItems(items: [GroupItem]) -> [NSIndexPath]?
    func indexPathsForItemOfType(itemType: GroupItem.Type) -> [NSIndexPath]?
}

class GroupedListViewModel: ListViewModel<GroupItem> {
    
    init(items: [[GroupItem]]) {
        super.init(sections: items.map { Section($0) })
    }
}

extension GroupedListViewModel: ExtendedIndexPathOperatable {
    
    func indexPathsForItems(items: [GroupItem]) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []
        
        itemize { (path, item) -> () in
            if items.contains(item) {
                indexPaths.append(NSIndexPath(forRow: path.row, inSection: path.section))
            }
        }
        
        return indexPaths.isEmpty ? nil : indexPaths
    }
    
    func indexPathsForItemOfType<T>(itemType: T.Type) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []
        
        itemize { path, item in
            if item is T {
                indexPaths.append(NSIndexPath(forRow: path.row, inSection: path.section))
            }
        }
        return indexPaths.isEmpty ? nil : indexPaths
    }
}
