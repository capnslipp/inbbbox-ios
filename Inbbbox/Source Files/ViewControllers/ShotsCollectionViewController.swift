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

    @available(*, unavailable, message="Use init() method instead")
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
        collectionView?.backgroundView = ShotsCollectionBackgroundView()
        collectionView?.registerClass(ShotCollectionViewCell.self, type: .Cell)

        configureForCurrentStateHandler()
        registerToSettingsNotifications()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stateHandler.prepareForPresentingData()
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
                let alertController = self.signOutAlertController()
                self.presentViewController(alertController, animated: true, completion: nil)
                alertController.view.tintColor = .pinkColor()
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension ShotsCollectionViewController {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateHandler.collectionView(collectionView, numberOfItemsInSection: section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return stateHandler.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
}

// MARK: UICollectionViewDelegate
extension ShotsCollectionViewController {

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        stateHandler.collectionView?(collectionView, didSelectItemAtIndexPath: indexPath)
    }

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        stateHandler.collectionView?(collectionView, willDisplayCell: cell, forItemAtIndexPath: indexPath)
    }
}

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
        collectionView?.setContentOffset(CGPointZero, animated: false)
    }

    func registerToSettingsNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didChangeStreamSourceSettings:", name: InbbboxNotificationKey.UserDidChangeStreamSourceSettings.rawValue, object: nil)
    }

    dynamic func didChangeStreamSourceSettings(notification: NSNotification) {
        firstly {
            refreshShotsData()
        }.then {
            self.collectionView?.reloadData()
        }.error { error in
            // NGRTemp: Need mockups for error message view
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

    func signOutAlertController() -> UIAlertController {
        let alertController = UIAlertController(
            title: NSLocalizedString("Error occurred", comment: ""),
            message: NSLocalizedString("Signing out...", comment: ""),
            preferredStyle: .Alert
        )
        let logoutAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .Cancel) { _ in
            Authenticator.logout()
            UIApplication.sharedApplication().keyWindow?.setRootViewController(LoginViewController(), transition: nil)
        }
        alertController.addAction(logoutAction)
        return alertController
    }
}
