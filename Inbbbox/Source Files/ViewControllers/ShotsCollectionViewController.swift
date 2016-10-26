//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyUserDefaults

class ShotsCollectionViewController: UICollectionViewController {

    enum State {
        case Onboarding, InitialAnimations, Normal
    }

    let initialState: State = Defaults[.onboardingPassed] ? .InitialAnimations : .Onboarding
    var stateHandler: ShotsStateHandler
    let shotsProvider = ShotsProvider()
    var shots = [ShotType]()
    private var onceTokenForInitialShotsAnimation = dispatch_once_t(0)

    // MARK: Life cycle

    @available(*, unavailable, message = "Use init() method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Initializer which creates ShotsCollectionViewController,
     with proper collection view layout, according to current state
     */

    init() {
        stateHandler = ShotsStateHandlersProvider().shotsStateHandlerForState(initialState)
        super.init(collectionViewLayout: stateHandler.collectionViewLayout)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: UIViewController

extension ShotsCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.pagingEnabled = true
        // NGRTodo: iOS 10 only API. Remove after updating project.
        #if swift(>=2.3)
        if #available(iOS 10.0, *) {
            collectionView?.prefetchDataSource = self
        }
        #endif
        collectionView?.backgroundView = ShotsCollectionBackgroundView()
        collectionView?.registerClass(ShotCollectionViewCell.self, type: .Cell)

        configureForCurrentStateHandler()
        registerToSettingsNotifications()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stateHandler.prepareForPresentingData()
        stateHandler.collectionViewLayout.prepareLayout()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        AnalyticsManager.trackScreen(.ShotsView)

        dispatch_once(&onceTokenForInitialShotsAnimation) {
            firstly {
                self.refreshShotsData()
            }.then {
                self.stateHandler.presentData()
            }.error { error in
                let alertController = UIAlertController.willSignOutUser()
                self.tabBarController?.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension ShotsCollectionViewController {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateHandler.collectionView(collectionView, numberOfItemsInSection: section)
    }

    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = stateHandler.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? ShotCollectionViewCell {
            if !cell.isRegisteredTo3DTouch {
                cell.isRegisteredTo3DTouch = registerTo3DTouch(cell.contentView)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegate

extension ShotsCollectionViewController {

    override func collectionView(collectionView: UICollectionView,
                                 didSelectItemAtIndexPath indexPath: NSIndexPath) {
        stateHandler.collectionView?(collectionView, didSelectItemAtIndexPath: indexPath)
    }

    override func collectionView(collectionView: UICollectionView,
                                 willDisplayCell cell: UICollectionViewCell,
                                 forItemAtIndexPath indexPath: NSIndexPath) {
        stateHandler.collectionView?(collectionView, willDisplayCell: cell, forItemAtIndexPath: indexPath)
    }

    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell,
                                 forItemAtIndexPath indexPath: NSIndexPath) {
        if stateHandler is ShotsNormalStateHandler {
            stateHandler.collectionView?(collectionView, didEndDisplayingCell: cell, forItemAtIndexPath: indexPath)
        }
    }
}

// NGRTodo: iOS 10 only API. Remove after updating project.
#if swift(>=2.3)
extension ShotsCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(collectionView: UICollectionView, prefetchItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        if let stateHandler = stateHandler as? ShotsNormalStateHandler {
            stateHandler.collectionView(collectionView, prefetchItemsAtIndexPaths: indexPaths)
        }
    }

    func collectionView(collectionView: UICollectionView, cancelPrefetchingForItemsAtIndexPaths indexPaths: [NSIndexPath]) {
        if let stateHandler = stateHandler as? ShotsNormalStateHandler {
            stateHandler.collectionView(collectionView, cancelPrefetchingForItemsAtIndexPaths: indexPaths)
        }
    }
}
#endif

// MARK: UIScrollViewDelegate

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
        if let newState = shotsStateHandler.nextState {
            stateHandler = ShotsStateHandlersProvider().shotsStateHandlerForState(newState)
            configureForCurrentStateHandler()
            stateHandler.prepareForPresentingData()
            stateHandler.presentData()
        }
    }

    func shotsStateHandlerDidFailToFetchItems(error: ErrorType) {
        let alert = UIAlertController.unableToDownloadItems()
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK: Private methods

private extension ShotsCollectionViewController {

    func configureForCurrentStateHandler() {
        stateHandler.shotsCollectionViewController = self
        stateHandler.delegate = self
        tabBarController?.tabBar.userInteractionEnabled = stateHandler.tabBarInteractionEnabled
        tabBarController?.tabBar.alpha = stateHandler.tabBarAlpha
        collectionView?.userInteractionEnabled = stateHandler.collectionViewInteractionEnabled
        collectionView?.scrollEnabled = stateHandler.collectionViewScrollEnabled
        collectionView?.setCollectionViewLayout(stateHandler.collectionViewLayout, animated: false)
        collectionView?.setContentOffset(CGPoint.zero, animated: false)

        if let normalStateHandler = stateHandler as? ShotsNormalStateHandler, centerButtonTabBarController = tabBarController as? CenterButtonTabBarController {
            normalStateHandler.didLikeShotCompletionHandler = {
                centerButtonTabBarController.animateTabBarItem(.Likes)
            }
            normalStateHandler.didAddShotToBucketCompletionHandler = {
                centerButtonTabBarController.animateTabBarItem(.Buckets)
            }
        }
    }

    func registerToSettingsNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didChangeStreamSourceSettings(_:)),
        name: InbbboxNotificationKey.UserDidChangeStreamSourceSettings.rawValue, object: nil)
    }

    dynamic func didChangeStreamSourceSettings(notification: NSNotification) {
        firstly {
            refreshShotsData()
        }.then { () -> Void in
            self.collectionView?.reloadData()
            self.collectionView?.setContentOffset(CGPointZero, animated: true)
        }.error { error in
            let alert = UIAlertController.unableToDownloadItems()
            self.tabBarController?.presentViewController(alert, animated: true, completion: nil)
        }
    }

    func refreshShotsData() -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            firstly {
                self.shotsProvider.provideShots()
            }.then { shots -> Void in
                self.shots = shots ?? []
            }.then(fulfill).error(reject)
        }
    }
}

// MARK: UIViewControllerPreviewingDelegate

extension ShotsCollectionViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard
            let visibleCell = collectionView?.visibleCells().first,
            let normalStateHandler = stateHandler as? ShotsNormalStateHandler,
            let indexPath = collectionView?.indexPathsForVisibleItems().first
        else { return nil }
        
        previewingContext.sourceRect = visibleCell.contentView.bounds
        
        return normalStateHandler.getShotDetailsViewController(atIndexPath: indexPath)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        if let normalStateHandler = stateHandler as? ShotsNormalStateHandler {
            normalStateHandler.popViewController(viewControllerToCommit)
        }
    }
}
