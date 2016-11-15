//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import PromiseKit

class ShotsOnboardingStateHandler: NSObject, ShotsStateHandler {

    private let connectionsRequester = APIConnectionsRequester()
    private let userProvider = APIUsersProvider()
    private let netguruIdentifier = "netguru"
    
    weak var shotsCollectionViewController: ShotsCollectionViewController?
    weak var delegate: ShotsStateHandlerDelegate?
    let onboardingSteps: [(image: UIImage?, action: ShotCollectionViewCell.Action)]


    var scrollViewAnimationsCompletion: (() -> Void)?

    var state: ShotsCollectionViewController.State {
        return .Onboarding
    }

    var nextState: ShotsCollectionViewController.State? {
        return .Normal
    }

    var tabBarInteractionEnabled: Bool {
        return false
    }

    var tabBarAlpha: CGFloat {
        return 0.3
    }

    var collectionViewLayout: UICollectionViewLayout {
        return ShotsCollectionViewFlowLayout()
    }

    var collectionViewInteractionEnabled: Bool {
        return true
    }

    var collectionViewScrollEnabled: Bool {
        return false
    }
    
    var shouldShowNoShotsView: Bool {
        return false
    }

    func prepareForPresentingData() {
        // Do nothing, all set.
    }

    func presentData() {
        shotsCollectionViewController?.collectionView?.reloadData()
    }

    override init() {
        let step1 = NSLocalizedString("ShotsOnboardingStateHandler.Onboarding-Step1", comment: "")
        let step2 = NSLocalizedString("ShotsOnboardingStateHandler.Onboarding-Step2", comment: "")
        let step3 = NSLocalizedString("ShotsOnboardingStateHandler.Onboarding-Step3", comment: "")
        let step4 = NSLocalizedString("ShotsOnboardingStateHandler.Onboarding-Step4", comment: "")
        onboardingSteps = [
            (image: UIImage(named: step1), action: ShotCollectionViewCell.Action.Like),
            (image: UIImage(named: step2), action: ShotCollectionViewCell.Action.Bucket),
            (image: UIImage(named: step3), action: ShotCollectionViewCell.Action.Comment),
            (image: UIImage(named: step4), action: ShotCollectionViewCell.Action.Follow),
        ]
    }
}

// MARK: UICollectionViewDataSource
extension ShotsOnboardingStateHandler {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return onboardingSteps.count
        }
        return onboardingSteps.count + shotsCollectionViewController.shots.count
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row < onboardingSteps.count {
            return cellForOnboardingShot(collectionView, indexPath: indexPath)
        } else {
            return cellForShot(collectionView, indexPath: indexPath)
        }
    }
}

// MARK: UICollectionViewDelegate
extension ShotsOnboardingStateHandler {
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell,
                        forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == onboardingSteps.count {
            scrollViewAnimationsCompletion = {
                Defaults[.onboardingPassed] = true
                self.delegate?.shotsStateHandlerDidInvalidate(self)
            }
        }
    }
}

// MARK: UIScrollViewDelegate
extension ShotsOnboardingStateHandler {
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        scrollViewAnimationsCompletion?()
        scrollViewAnimationsCompletion = nil
    }
}

// MARK: Private methods
private extension ShotsOnboardingStateHandler {

    func cellForShot(collectionView: UICollectionView, indexPath: NSIndexPath) -> ShotCollectionViewCell {
        guard let shotsCollectionViewController = shotsCollectionViewController else {
            return ShotCollectionViewCell()
        }
        let shot = shotsCollectionViewController.shots[0]
        let cell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self,
                forIndexPath: indexPath, type: .Cell)
        cell.shotImageView.loadShotImageFromURL(shot.shotImage.normalURL)
        cell.displayAuthor(Settings.Customization.ShowAuthor, animated: false)
        cell.gifLabel.hidden = !shot.animated
        return cell
    }

    func cellForOnboardingShot(collectionView: UICollectionView, indexPath: NSIndexPath) -> ShotCollectionViewCell {
        let cell = collectionView.dequeueReusableClass(ShotCollectionViewCell.self,
                forIndexPath: indexPath, type: .Cell)
        let stepImage = onboardingSteps[indexPath.row].image
        cell.shotImageView.image = stepImage
        cell.gifLabel.hidden = true
        cell.enabledActions = [self.onboardingSteps[indexPath.row].action]
        cell.swipeCompletion = { [weak self] action in
            if action == self?.onboardingSteps[indexPath.row].action {
                var newContentOffset = collectionView.contentOffset
                newContentOffset.y += CGRectGetHeight(collectionView.bounds)
                collectionView.setContentOffset(newContentOffset, animated: true)
                
                if action == .Follow {
                    self?.followNetguru()
                }
            }
        }
        return cell
    }
    
    func followNetguru() {
        firstly { _ in
            userProvider.provideUser(netguruIdentifier)
        }.then { user in
            self.connectionsRequester.followUser(user)
        }
    }
}
