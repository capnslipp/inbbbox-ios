//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

class ShotsInitialAnimationsStateHandler: NSObject, ShotsStateHandler {

    let animationManager = ShotsAnimator()
    weak var shotsCollectionViewController: ShotsCollectionViewController? {
        didSet {
            shotsCollectionViewController?.collectionView?.emptyDataSetSource = self
        }
    }
    
    weak var delegate: ShotsStateHandlerDelegate?

    var state: ShotsCollectionViewController.State {
        return .InitialAnimations
    }

    var nextState: ShotsCollectionViewController.State? {
        return .Normal
    }

    var collectionViewLayout: UICollectionViewLayout {
        return InitialAnimationsShotsCollectionViewLayout()
    }
    
    var tabBarInteractionEnabled: Bool {
        return false
    }
    
    var collectionViewInteractionEnabled: Bool {
        return false
    }
    
    var colletionViewScrollEnabled: Bool {
        return false
    }
    
    private let emptyDataSetLoadingView = EmptyDataSetLoadingView.newAutoLayoutView()

    override init () {
        super.init()
        animationManager.delegate = self
    }
    
    func presentData() {
        hideEmptyDataSetLoadingView()
        self.animationManager.startAnimationWithCompletion() {
            self.delegate?.shotsStateHandlerDidInvalidate(self)
        }
    }
}

// MARK: UICollecitonViewDataSource

extension ShotsInitialAnimationsStateHandler {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.animationManager.visibleItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self, forIndexPath: indexPath, type: .Cell)
        let shot = shotsCollectionViewController.shots[indexPath.item]
        let shouldBlurShotImage = indexPath.row != 0
        let blur = shouldBlurShotImage ? CGFloat(1) : CGFloat(0)
        cell.shotImageView.loadShotImageFromURL(shot.shotImage.normalURL, blur: blur)
        cell.gifLabel.hidden = !shot.animated
        return cell
    }
}

extension ShotsInitialAnimationsStateHandler: ShotsAnimatorDelegate {

    func collectionViewForShotsAnimator(animator: ShotsAnimator) -> UICollectionView? {
        return shotsCollectionViewController?.collectionView
    }

    func itemsForShotsAnimator(animator: ShotsAnimator) -> [ShotType] {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return []
        }
        return Array(shotsCollectionViewController.shots.prefix(3))
    }
}

extension ShotsInitialAnimationsStateHandler: DZNEmptyDataSetSource {
    
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
        emptyDataSetLoadingView.startAnimation()
        return emptyDataSetLoadingView
    }
}

// MARK: Private methods

private extension ShotsInitialAnimationsStateHandler {
    
    // NGRHack: DZNEmptyDataSet does not react on `insertItemsAtIndexPaths` so we need to manually hide loading view
    func hideEmptyDataSetLoadingView() {
        emptyDataSetLoadingView.hidden = true
        emptyDataSetLoadingView.stopAnimation()
    }
}