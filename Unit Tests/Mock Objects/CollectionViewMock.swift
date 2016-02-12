//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Dobby

@testable import Inbbbox

class CollectionViewMock: UICollectionView {

    let numberOfItemsInSectionStub = Stub<Int, Int>()
    let insertItemsAtIndexPathsStub = Stub<[NSIndexPath], Void>()
    let deleteItemsAtIndexPathsStub = Stub<[NSIndexPath], Void>()
    let performBatchUpdatesStub = Stub<((() -> Void)?, (Bool -> Void)?), Void>()
    let reloadDataStub = Stub<Void, Void>()
    let dequeueReusableCellWithReuseIdentifierStub = Stub<(String, NSIndexPath), UICollectionViewCell>()
    let visibleCellsStub = Stub<Void, [UICollectionViewCell]>()
    let indexPathForCellStub = Stub<UICollectionViewCell, NSIndexPath>()

    convenience init() {
        self.init(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func numberOfItemsInSection(section: Int) -> Int {
        return try! numberOfItemsInSectionStub.invoke(section)
    }

    override func insertItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        try! insertItemsAtIndexPathsStub.invoke(indexPaths)
    }

    override func deleteItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        try! deleteItemsAtIndexPathsStub.invoke(indexPaths)
    }

    override func performBatchUpdates(updates: (() -> Void)?, completion: (Bool -> Void)?) {
        try! performBatchUpdatesStub.invoke(updates, completion)
    }

    override func reloadData() {
        try! reloadDataStub.invoke()
    }

    override func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return try! dequeueReusableCellWithReuseIdentifierStub.invoke(identifier, indexPath)
    }

    override func visibleCells() -> [UICollectionViewCell] {
        return try! visibleCellsStub.invoke()
    }

    override func indexPathForCell(cell: UICollectionViewCell) -> NSIndexPath? {
        return try! indexPathForCellStub.invoke(cell)
    }
}
