//
//  UserDetailsViewModel.swift
//  Inbbbox
//
//  Created by Peter Bruz on 14/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

final class UserDetailsViewModel: BaseCollectionViewViewModel {
    
    var delegate: BaseCollectionViewViewModelDelegate?
    
    private(set) var user: UserType
    var userShots = [ShotType]()
    private let shotsProvider = ShotsProvider()
    private let connectionsRequester = APIConnectionsRequester()
    
    
    var shouldShowFollowButton: Bool {
        return UserStorage.isUserSignedIn
    }
    var itemsCount: Int {
        return userShots.count
    }
    
    init(user: UserType) {
        self.user = user
    }
    
    // MARK: Shots section
    
    func downloadInitialItems() {
        firstly {
            shotsProvider.provideShotsForUser(user)
        }.then { shots -> Void in
            if let shots = shots where shots != self.userShots {
                self.userShots = shots
                self.delegate?.viewModelDidLoadInitialItems()
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    func downloadItemsForNextPage() {
        firstly {
            shotsProvider.nextPage()
        }.then { shots -> Void in
            if let shots = shots where shots.count > 0 {
                let indexes = shots.enumerate().map { index, _ in
                    return index + self.userShots.count
                }
                self.userShots.appendContentsOf(shots)
                let indexPaths = indexes.map {
                    NSIndexPath(forRow:($0), inSection: 0)
                }
                self.delegate?.viewModel(self, didLoadItemsAtIndexPaths: indexPaths)
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    // MARK: Users section
    
    func isUserFollowedByMe() -> Promise<Bool> {
        
        guard UserStorage.isUserSignedIn else {
            return Promise(false)
        }
        
        return Promise<Bool> { fulfill, reject in
            
            firstly {
                connectionsRequester.isUserFollowedByMe(user)
            }.then { followed in
                fulfill(followed)
            }.error(reject)
        }
    }
    
    func followUser() -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            firstly {
                connectionsRequester.followUser(user)
            }.then(fulfill).error(reject)
        }
    }
    
    func unfollowUser() -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            firstly {
                connectionsRequester.unfollowUser(user)
            }.then(fulfill).error(reject)
        }
    }
    
    // MARK: Cell data section
    
    func shotCollectionViewCellViewData(indexPath: NSIndexPath) -> (imageURL: NSURL, animated: Bool) {
        let imageURL = userShots[indexPath.row].shotImage.normalURL
        let animated = userShots[indexPath.row].animated
        return (imageURL, animated)
    }
}

// MARK: Helpers

extension UserDetailsViewModel {
    
    func shotWithSwappedUser(shot: ShotType) -> ShotType {
        return Shot(
            identifier: shot.identifier,
            title: shot.title,
            attributedDescription: shot.attributedDescription,
            user: user,
            shotImage: shot.shotImage,
            createdAt: shot.createdAt,
            animated: shot.animated,
            likesCount: shot.likesCount,
            viewsCount: shot.viewsCount,
            commentsCount: shot.commentsCount,
            bucketsCount: shot.bucketsCount,
            team: shot.team
        )
    }
}
