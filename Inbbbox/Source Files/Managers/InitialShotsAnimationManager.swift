//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol InitialShotsAnimationManagerDelegate: class {
    func collectionViewForAnimationManager(animationManager: InitialShotsAnimationManager) -> UICollectionView?

    func itemsForAnimationManager(animationManager: InitialShotsAnimationManager) -> [AnyObject]
}

class InitialShotsAnimationManager {

    weak var delegate: InitialShotsAnimationManagerDelegate?
    var visibleItems = [AnyObject]()
    var closureExecutor = ClosureExecutor()

//    Interface

    func startAnimationWithCompletion(completion: (Void -> Void)?) {
        guard let collectionView = delegate?.collectionViewForAnimationManager(self), items = delegate?.itemsForAnimationManager(self) else {
            return
        }

        let interval = 0.1
        addItems(items, collectionView: collectionView, interval: interval) {
            self.closureExecutor.executeClosureOnMainThread(delay: 1.0) {
                self.deleteItemsWithoutFirstItem(items, collectionView: collectionView, interval: interval, completion: completion)
            }
        }
    }

//    MARK: - Helpers

    private func addItems(items: [AnyObject], collectionView: UICollectionView, interval: Double, completion: (Void -> Void)?) {
        let addItemAnimation = {
            let newItemIndex = self.visibleItems.count
            let newItem = items[newItemIndex]
            self.visibleItems.append(newItem)
            collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: newItemIndex, inSection: 0)])
        }

        updateItems(items, collectionView: collectionView, interval: interval, animation: addItemAnimation, completion: completion)
    }

    private func deleteItemsWithoutFirstItem(items: [AnyObject], collectionView: UICollectionView, interval: Double, completion: (Void -> Void)?) {
        var reversedItemsWithoutFirstItem = items
        reversedItemsWithoutFirstItem.removeFirst()
        reversedItemsWithoutFirstItem.reverse()

        let removeItemAnimation = {
            let lastItemIndex = self.visibleItems.count - 1
            self.visibleItems.removeLast()
            collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: lastItemIndex, inSection: 0)])
        }

        self.updateItems(reversedItemsWithoutFirstItem, collectionView: collectionView, interval: interval, animation: removeItemAnimation, completion: completion)
    }

    private func updateItems(items: [AnyObject], collectionView: UICollectionView, interval: Double, animation: Void -> Void, completion: (Void -> Void)?) {
        for itemIndex in 1 ... items.count {
            var updateAnimation = animation
            if itemIndex == items.count {
                let batchUpdatesCompletion: (Bool -> Void) = { Bool in
                    completion?()
                }
                updateAnimation = {
                    collectionView.performBatchUpdates(animation, completion: batchUpdatesCompletion)
                }
            }
            self.closureExecutor.executeClosureOnMainThread(delay: Double(itemIndex) * interval, closure: updateAnimation)
        }
    }
}
