//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol InitialShotsAnimationManagerDelegate: class {
    func collectionViewForAnimationManager(_ animationManager: InitialShotsAnimationManager) -> UICollectionView?

    func itemsForAnimationManager(_ animationManager: InitialShotsAnimationManager) -> [AnyObject]
}

class InitialShotsAnimationManager {

    weak var delegate: InitialShotsAnimationManagerDelegate?
    var visibleItems = [AnyObject]()

//    Interface

    func startAnimationWithCompletion(completion: (Void -> Void)?) {
//        NGRTemp: temporary implementation
        guard let collectionView = delegate?.collectionViewForAnimationManager(self), items = delegate?.itemsForAnimationManager(self) else {
            return
        }

        let secondMultiplier = 0.1

        for itemIndex in 1 ... items.count {
            delay(Double(itemIndex) * secondMultiplier) {
                self.insertNewItem()
            }
        }

        delay(1.0 + Double(items.count) * secondMultiplier) {

            for itemIndex in (1 ... items.count - 1).reverse() {

                self.delay(Double(itemIndex) * secondMultiplier) {
                    if (itemIndex != items.count - 2) {
                        self.deleteLastItem()
                    } else {
                        collectionView.performBatchUpdates({
                            self.deleteLastItem()
                        }, completion: {
                            Bool in
                            completion?()
                        })
                    }
                }
            }
        }
    }

//    MARK: - Helpers

    private func delay(delay: Double, closure: Void -> Void) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }

    private func insertNewItem() {
        if let delegate = delegate, collectionView = delegate.collectionViewForAnimationManager(self) {
            let items = delegate.itemsForAnimationManager(self)
            let newItemIndex = visibleItems.count
            let newItem = items[newItemIndex]
            visibleItems.append(newItem)
            collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: newItemIndex, inSection: 0)])
        }
    }

    private func deleteLastItem() {
        if let delegate = delegate, collectionView = delegate.collectionViewForAnimationManager(self) {
            let items = delegate.itemsForAnimationManager(self)
            let lastItemIndex = visibleItems.count - 1
            visibleItems.removeLast()
            collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: lastItemIndex, inSection: 0)])
        }
    }
}
