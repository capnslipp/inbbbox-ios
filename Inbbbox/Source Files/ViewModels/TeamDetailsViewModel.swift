//
//  TeamDetailsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 04/05/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

class TeamDetailsViewModel: ProfileViewModel {

    weak var delegate: BaseCollectionViewViewModelDelegate?

    var title: String {
        return team.name
    }

    var avatarURL: NSURL? {
        return team.avatarURL
    }

    var collectionIsEmpty: Bool {
        return teamMembers.isEmpty
    }

    var shouldShowFollowButton: Bool {
        return UserStorage.isUserSignedIn
    }

    var itemsCount: Int {
        return teamMembers.count
    }

    var teamMembers = [UserType]()
    var memberIndexedShots = [Int: [ShotType]]()

    private let connectionsRequester = APIConnectionsRequester()
    private let teamsProvider = APITeamsProvider()
    private let connectionsProvider = APIConnectionsProvider()
    private let shotsProvider = ShotsProvider()

    private let team: TeamType

    init(team: TeamType) {
        self.team = team
    }

    func downloadInitialItems() {

        firstly {
            teamsProvider.provideMembersForTeam(team)
        }.then { teamMembers -> Void in
            if let teamMembers = teamMembers where teamMembers != self.teamMembers || teamMembers.count == 0 {
                self.teamMembers = teamMembers
                self.downloadShots(teamMembers)
                self.delegate?.viewModelDidLoadInitialItems()
            }
        }.error { error in
            self.delegate?.viewModelDidFailToLoadInitialItems(error)
        }
    }

    func downloadItemsForNextPage() {

        firstly {
            UserStorage.isUserSignedIn ? connectionsProvider.nextPage() : teamsProvider.nextPage()
        }.then { teamMembers -> Void in
            if let teamMembers = teamMembers where teamMembers.count > 0 {
                let indexes = teamMembers.enumerate().map { index, _ in
                    return index + self.teamMembers.count
                }
                self.teamMembers.appendContentsOf(teamMembers)
                let indexPaths = indexes.map {
                    NSIndexPath(forRow: ($0), inSection: 0)
                }
                self.delegate?.viewModel(self, didLoadItemsAtIndexPaths: indexPaths)
                self.downloadShots(teamMembers)
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
        }
    }

    func isProfileFollowedByMe() -> Promise<Bool> {

        return Promise<Bool> { fulfill, reject in
            firstly {
                connectionsRequester.isTeamFollowedByMe(team)
            }.then(fulfill).error(reject)
        }
    }

    func followProfile() -> Promise<Void> {

        return Promise<Void> { fulfill, reject in
            firstly {
                connectionsRequester.followTeam(team)
            }.then(fulfill).error(reject)
        }
    }

    func unfollowProfile() -> Promise<Void> {

        return Promise<Void> { fulfill, reject in
            firstly {
                connectionsRequester.unfollowTeam(team)
            }.then(fulfill).error(reject)
        }
    }

    func userCollectionViewCellViewData(indexPath: NSIndexPath) -> UserCollectionViewCellViewData {
        return UserCollectionViewCellViewData(user: teamMembers[indexPath.row],
                                                  shots: memberIndexedShots[indexPath.row])
    }
}

extension TeamDetailsViewModel {

    struct UserCollectionViewCellViewData {
        let name: String?
        let avatarURL: NSURL?
        let numberOfShots: String
        let shotsImagesURLs: [NSURL]?
        let firstShotImage: ShotImageType?

        init(user: UserType, shots: [ShotType]?) {
            self.name = user.name
            self.avatarURL = user.avatarURL
            self.numberOfShots = String.localizedStringWithFormat(NSLocalizedString("%d shots",
                comment: "How many shots in collection?"), user.shotsCount)
            if let shots = shots where shots.count > 0 {

                let allShotsImagesURLs = shots.map { $0.shotImage.teaserURL }

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

private extension TeamDetailsViewModel {
    func downloadShots(teamMembers: [UserType]) {
        for member in teamMembers {
            firstly {
                shotsProvider.provideShotsForUser(member)
            }.then { shots -> Void in
                var indexOfMember: Int?
                for (index, item) in self.teamMembers.enumerate() {
                    if item.identifier == member.identifier {
                        indexOfMember = index
                        break
                    }
                }

                guard let index = indexOfMember else { return }

                if let shots = shots {
                    self.memberIndexedShots[index] = shots
                } else {
                    self.memberIndexedShots[index] = [ShotType]()
                }
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.delegate?.viewModel(self, didLoadShotsForItemAtIndexPath: indexPath)
            }.error { error in
                // NGRTemp: Need mockups for error message view
            }
        }
    }
}
