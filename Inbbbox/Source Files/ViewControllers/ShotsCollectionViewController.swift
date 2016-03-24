//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class ShotsCollectionViewController: UICollectionViewController {

    enum State {
        case Onboarding, InitialAnimations, Normal
    }

    var stateHandler: ShotsStateHandler
    let shotsProvider = ShotsProvider()
    var shots = [ShotType]()
    private var onceTokenForInitialShotsAnimation = dispatch_once_t(0)

    //MARK - Life cycle

    @available(*, unavailable, message="Use init() method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        let state: State = NSUserDefaults.standardUserDefaults().boolForKey("OnboardingPassed") ? .InitialAnimations : .Onboarding
        stateHandler = ShotsStateHandlersProvider().shotsStateHandlerForState(state)
        super.init(collectionViewLayout: stateHandler.collectionViewLayout)
        stateHandler.shotsCollectionViewController = self
        stateHandler.delegate = self
    }
}

//MARK - UIViewController
extension ShotsCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.pagingEnabled = true
        collectionView?.backgroundView = ShotsCollectionBackgroundView()
        collectionView?.registerClass(ShotCollectionViewCell.self, type: .Cell)
        collectionView?.userInteractionEnabled = stateHandler.collectionViewInteractionEnabled
        collectionView?.scrollEnabled = stateHandler.colletionViewScrollEnabled
        tabBarController?.tabBar.userInteractionEnabled = stateHandler.tabBarInteractionEnabled
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        AnalyticsManager.trackScreen(.ShotsView)

        dispatch_once(&onceTokenForInitialShotsAnimation) {
            firstly {
                self.shotsProvider.provideShots()
                }.then { shots -> Void in
                    if let shots = shots {
                        self.shots = shots
                        self.stateHandler.presentData()
                    }
                }.error { error in
                    // NGRTemp: Need mockups for error message view
                    print(error)
            }
        }
    }
}

//MARK - UICollectionViewDataSource
extension ShotsCollectionViewController {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateHandler.collectionView(collectionView, numberOfItemsInSection: section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return stateHandler.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
}

//MARK - UICollectionViewDelegate
extension ShotsCollectionViewController {

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        stateHandler.collectionView?(collectionView, didSelectItemAtIndexPath: indexPath)
    }

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        stateHandler.collectionView?(collectionView, willDisplayCell: cell, forItemAtIndexPath: indexPath)
    }
}

//MARK - UIScrollViewDelegate
extension ShotsCollectionViewController {
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        stateHandler.scrollViewDidEndDecelerating?(scrollView)
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        stateHandler.scrollViewDidScroll?(scrollView)
    }
    
    override func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        stateHandler.scrollViewDidEndScrollingAnimation?(scrollView)
    }
}

extension ShotsCollectionViewController: ShotsStateHandlerDelegate {
    
    func shotsStateHandlerDidInvalidate(shotsStateHandler: ShotsStateHandler) {
        if let nextState = shotsStateHandler.nextState {
            stateHandler = ShotsStateHandlersProvider().shotsStateHandlerForState(nextState)
            stateHandler.shotsCollectionViewController = self
            stateHandler.delegate = self
            collectionView?.userInteractionEnabled = stateHandler.collectionViewInteractionEnabled
            tabBarController?.tabBar.userInteractionEnabled = stateHandler.tabBarInteractionEnabled
            collectionView?.scrollEnabled = stateHandler.colletionViewScrollEnabled
            collectionView?.setCollectionViewLayout(stateHandler.collectionViewLayout, animated: false)
            collectionView?.setContentOffset(CGPointZero, animated: false)
            stateHandler.presentData()
        }
    }
}
