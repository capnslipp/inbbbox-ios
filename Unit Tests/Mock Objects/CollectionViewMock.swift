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
}
