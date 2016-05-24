//
//  FolloweesViewModel.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 26.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

class FolloweesViewModel: BaseCollectionViewViewModel {

    weak var delegate: BaseCollectionViewViewModelDelegate?
    let title = NSLocalizedString("Following", comment:"")
    var followees = [Followee]()
    var followeesIndexedShots = [Int: [ShotType]]()
    private let teamsProvider = APITeamsProvider()
    private let connectionsProvider = APIConnectionsProvider()
    private let shotsProvider = ShotsProvider()
    private var userMode: UserMode

    private let netguruTeam = Team(identifier: "653174", name: "", username: "", avatarURL: nil, createdAt: NSDate())

    var itemsCount: Int {
        return followees.count
    }

    init() {
        userMode = UserStorage.isUserSignedIn ? .LoggedUser : .DemoUser
    }

    func downloadInitialItems() {

        firstly {
            UserStorage.isUserSignedIn ?
                    connectionsProvider.provideMyFollowees() : teamsProvider.provideMembersForTeam(netguruTeam)
        }.then { followees -> Void in
            if let followees = followees where followees != self.followees || followees.count == 0 {
                self.followees = followees
                self.downloadShots(followees)
                self.delegate?.viewModelDidLoadInitialItems()
            }
        }.error {
            error in
            self.delegate?.viewModelDidFailToLoadInitialItems(error)
        }
    }

    func downloadItemsForNextPage() {

        firstly {
            UserStorage.isUserSignedIn ? connectionsProvider.nextPage() : teamsProvider.nextPage()
        }.then {
            followees -> Void in
            if let followees = followees where followees.count > 0 {
                let indexes = followees.enumerate().map {
                    index, _ in
                    return index + self.followees.count
                }
                self.followees.appendContentsOf(followees)
                let indexPaths = indexes.map {
                    NSIndexPath(forRow: ($0), inSection: 0)
                }
                self.delegate?.viewModel(self, didLoadItemsAtIndexPaths: indexPaths)
                self.downloadShots(followees)
            }
        }.error { error in
            self.notifyDelegateAboutFailure(error)
        }
    }

    func downloadShots(followees: [Followee]) {
        for followee in followees {
            firstly {
                shotsProvider.provideShotsForUser(followee)
            }.then {
                shots -> Void in
                var indexOfFollowee: Int?
                for (index, item) in self.followees.enumerate() {
                    if item.identifier == followee.identifier {
                        indexOfFollowee = index
                        break
                    }
                }
                guard let index = indexOfFollowee else {
                    return
                }
                if let shots = shots {
                    self.followeesIndexedShots[index] = shots
                } else {
                    self.followeesIndexedShots[index] = [ShotType]()
                }
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.delegate?.viewModel(self, didLoadShotsForItemAtIndexPath: indexPath)
            }.error { error in
                self.notifyDelegateAboutFailure(error)
            }
        }
    }

    func followeeCollectionViewCellViewData(indexPath: NSIndexPath) -> FolloweeCollectionViewCellViewData {
        return FolloweeCollectionViewCellViewData(followee: followees[indexPath.row],
                shots: followeesIndexedShots[indexPath.row])
    }

    func clearViewModelIfNeeded() {
        let currentUserMode = UserStorage.isUserSignedIn ? UserMode.LoggedUser : .DemoUser
        if userMode != currentUserMode {
            followees = []
            userMode = currentUserMode
            delegate?.viewModelDidLoadInitialItems()
        }
    }
}

extension FolloweesViewModel {

    struct FolloweeCollectionViewCellViewData {
        let name: String?
        let avatarURL: NSURL?
        let numberOfShots: String
        let shotsImagesURLs: [NSURL]?
        let firstShotImage: ShotImageType?

        init(followee: Followee, shots: [ShotType]?) {
            self.name = followee.name
            self.avatarURL = followee.avatarURL
            self.numberOfShots = String.localizedStringWithFormat(NSLocalizedString("%d shots",
                    comment: "How many shots in collection?"), followee.shotsCount)
            if let shots = shots where shots.count > 0 {
                let allShotsImagesURLs = shots.map {
                    $0.shotImage.teaserURL
                }
                switch allShotsImagesURLs.count {
                case 1:
                    shotsImagesURLs = [allShotsImagesURLs[0], allShotsImagesURLs[0],
                                       allShotsImagesURLs[0], allShotsImagesURLs[0]]
                case 2:
                    shotsImagesURLs = [allShotsImagesURLs[0], allShotsImagesURLs[1],
                                       allShotsImagesURLs[1], allShotsImagesURLs[0]]
                case 3:
                    shotsImagesURLs = [allShotsImagesURLs[0], allShotsImagesURLs[1],
                                       allShotsImagesURLs[2], allShotsImagesURLs[0]]
                default:
                    shotsImagesURLs = [allShotsImagesURLs[0], allShotsImagesURLs[1],
                                       allShotsImagesURLs[2], allShotsImagesURLs[3]]
                }
                firstShotImage = shots[0].shotImage
            } else {
                self.shotsImagesURLs = nil
                self.firstShotImage = nil
            }
        }
    }

}
