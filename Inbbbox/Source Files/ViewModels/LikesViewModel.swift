//
//  LikesViewModel.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 29.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit


class LikesViewModel: SimpleShotsViewModel {

    weak var delegate: BaseCollectionViewViewModelDelegate?
    let title = NSLocalizedString("LikesViewModel.Title", comment:"Title of Likes screen")
    var shots = [ShotType]()
    fileprivate let shotsProvider = ShotsProvider()
    fileprivate var userMode: UserMode

    var itemsCount: Int {
        return shots.count
    }

    init() {
        userMode = UserStorage.isUserSignedIn ? .loggedUser : .demoUser
    }

    func downloadInitialItems() {
        firstly {
            shotsProvider.provideMyLikedShots()
        }.then { shots -> Void in
            if let shots = shots, shots != self.shots || shots.count == 0 {
                self.shots = shots
                self.delegate?.viewModelDidLoadInitialItems()
            }
        }.error { error in
            self.delegate?.viewModelDidFailToLoadInitialItems(error)
        }
    }

    func downloadItemsForNextPage() {
        guard UserStorage.isUserSignedIn else {
            return
        }
        firstly {
            shotsProvider.nextPage()
        }.then { shots -> Void in
            if let shots = shots, shots.count > 0 {
                let indexes = shots.enumerate().map { index, _ in
                    return index + self.shots.count
                }
                self.shots.appendContentsOf(shots)
                let indexPaths = indexes.map {
                    NSIndexPath(forRow:($0), inSection: 0)
                }
                self.delegate?.viewModel(self, didLoadItemsAtIndexPaths: indexPaths)
            }
        }.error { error in
            self.notifyDelegateAboutFailure(error)
        }
    }

    func emptyCollectionDescriptionAttributes() -> EmptyCollectionViewDescription {
        let description = EmptyCollectionViewDescription(
            firstLocalizedString: NSLocalizedString("LikesCollectionView.EmptyData.FirstLocalizedString",
                comment: "LikesCollectionView, empty data set view"),
            attachmentImageName: "ic-like-emptystate",
            imageOffset: CGPoint(x: 0, y: -2),
            lastLocalizedString: NSLocalizedString("LikesCollectionView.EmptyData.LastLocalizedString",
                comment: "LikesCollectionView, empty data set view")
        )
        return description
    }

    func shotCollectionViewCellViewData(_ indexPath: IndexPath) -> (shotImage: ShotImageType, animated: Bool) {
        let shotImage = shots[(indexPath as NSIndexPath).row].shotImage
        let animated = shots[(indexPath as NSIndexPath).row].animated
        return (shotImage, animated)
    }

    func clearViewModelIfNeeded() {
        let currentUserMode = UserStorage.isUserSignedIn ? UserMode.loggedUser : .demoUser
        if userMode != currentUserMode {
            shots = []
            userMode = currentUserMode
            delegate?.viewModelDidLoadInitialItems()
        }
    }
}
