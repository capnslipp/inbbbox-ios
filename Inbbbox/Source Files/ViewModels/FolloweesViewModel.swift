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
    
    var delegate: BaseCollectionViewViewModelDelegate?
    let title = NSLocalizedString("Following", comment:"")
    var followees = [Followee]()
    var followeesIndexedShots = [Int : [ShotType]]()
    private let teamsProvider = APITeamsProvider()
    private let connectionsProvider = APIConnectionsProvider()
    private let shotsProvider = ShotsProvider()
    
    private let NetguruTeam = Team(identifier: "653174", name: "", username: "", avatarString: nil, createdAt: NSDate())
    
    var itemsCount: Int {
        return followees.count
    }
    
    func downloadInitialItems() {
        
        firstly {
            UserStorage.isUserSignedIn ? connectionsProvider.provideMyFollowees() : teamsProvider.provideMembersForTeam(NetguruTeam)
        }.then { followees -> Void in
            if let followees = followees where followees != self.followees {
                self.followees = followees
                self.downloadShots(followees)
                self.delegate?.viewModelDidLoadInitialItems()
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    func downloadItemsForNextPage() {
        
        firstly {
            UserStorage.isUserSignedIn ? connectionsProvider.nextPage() : teamsProvider.nextPage()
        }.then { followees -> Void in
            if let followees = followees where followees.count > 0 {
                let indexes = followees.enumerate().map { index, _ in
                    return index + self.followees.count
                }
                self.followees.appendContentsOf(followees)
                let indexPaths = indexes.map {
                    NSIndexPath(forRow:($0), inSection: 0)
                }
                self.delegate?.viewModel(self, didLoadItemsAtIndexPaths: indexPaths)
                self.downloadShots(followees)
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    func downloadShots(followees: [Followee]) {
        for followee in followees {
            firstly {
                shotsProvider.provideShotsForUser(followee)
            }.then { shots -> Void in
                var indexOfFollowee: Int?
                for (index, item) in self.followees.enumerate(){
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
                // NGRTemp: Need mockups for error message view
                print(error)
            }
        }
    }
    
    func followeeCollectionViewCellViewData(indexPath: NSIndexPath) -> FolloweeCollectionViewCellViewData {
        return FolloweeCollectionViewCellViewData(followee: followees[indexPath.row], shots: followeesIndexedShots[indexPath.row])
    }
}

extension FolloweesViewModel {
    
    struct FolloweeCollectionViewCellViewData {
        let name: String?
        let avatarString: String?
        let numberOfShots: String
        let shotsImagesURLs: [NSURL]?
        
        init(followee: Followee, shots: [ShotType]?) {
            self.name = followee.name
            self.avatarString = followee.avatarString
            self.numberOfShots = followee.shotsCount == 1 ? "\(followee.shotsCount) shot" : "\(followee.shotsCount) shots"
            if let shots = shots where shots.count > 0 {
                let allShotsImagesURLs = shots.map { $0.shotImage.normalURL }
                switch allShotsImagesURLs.count {
                case 1:
                    shotsImagesURLs = [allShotsImagesURLs[0], allShotsImagesURLs[0], allShotsImagesURLs[0], allShotsImagesURLs[0]]
                case 2:
                    shotsImagesURLs = [allShotsImagesURLs[0], allShotsImagesURLs[1], allShotsImagesURLs[1], allShotsImagesURLs[0]]
                case 3:
                    shotsImagesURLs = [allShotsImagesURLs[0], allShotsImagesURLs[1], allShotsImagesURLs[2], allShotsImagesURLs[0]]
                default:
                    shotsImagesURLs = [allShotsImagesURLs[0], allShotsImagesURLs[1], allShotsImagesURLs[2], allShotsImagesURLs[3]]
                }
            } else {
                self.shotsImagesURLs = nil
            }
        }
    }
}
