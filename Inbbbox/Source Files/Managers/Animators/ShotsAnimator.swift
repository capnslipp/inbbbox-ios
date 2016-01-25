//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol ShotsAnimatorDelegate: class {
    func collectionViewForShotsAnimator(animator: ShotsAnimator) -> UICollectionView?

    func itemsForShotsAnimator(animator: ShotsAnimator) -> [Shot]
}

class ShotsAnimator {

    weak var delegate: ShotsAnimatorDelegate?
    var visibleItems = [Shot]()
    var asyncWrapper = AsyncWrapper()

//    Interface

    func startAnimationWithCompletion(completion: (Void -> Void)?) {
        guard let collectionView = delegate?.collectionViewForShotsAnimator(self), items = delegate?.itemsForShotsAnimator(self) else {
            return
        }

        let interval = 0.1
        addItems(items, collectionView: collectionView, interval: interval) {
            self.asyncWrapper.main(after: 1.0) {
                self.deleteItemsWithoutFirstItem(items, collectionView: collectionView, interval: interval, completion: completion)
            }
        }
    }

//    MARK: - Helpers

    private func addItems(items: [Shot], collectionView: UICollectionView, interval: Double, completion: (Void -> Void)?) {
        let addItemAnimation = {
            let newItemIndex = self.visibleItems.count
            let newItem = items[newItemIndex]
            self.visibleItems.append(newItem)
            collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: newItemIndex, inSection: 0)])
        }

        updateItems(items, collectionView: collectionView, interval: interval, animation: addItemAnimation, completion: completion)
    }

    private func deleteItemsWithoutFirstItem(items: [Shot], collectionView: UICollectionView, interval: Double, completion: (Void -> Void)?) {
        var reversedItemsWithoutFirstItem = items
        reversedItemsWithoutFirstItem.removeFirst()

        let removeItemAnimation = {
            let lastItemIndex = self.visibleItems.count - 1
            self.visibleItems.removeLast()
            collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: lastItemIndex, inSection: 0)])
        }

        updateItems(reversedItemsWithoutFirstItem, collectionView: collectionView, interval: interval, animation: removeItemAnimation, completion: completion)
    }

    private func updateItems(items: [Shot], collectionView: UICollectionView, interval: Double, animation: Void -> Void, completion: (Void -> Void)?) {
        for (index, _ ) in items.enumerate() {
            var updateAnimation = animation
            if index == items.endIndex - 1 {
                let batchUpdatesCompletion: (Bool -> Void) = { _ in
                    completion?()
                }
                updateAnimation = {
                    collectionView.performBatchUpdates(animation, completion: batchUpdatesCompletion)
                }
            }
            asyncWrapper.main(after: Double(index + 1) * interval, block: updateAnimation)
        }
    }
}
