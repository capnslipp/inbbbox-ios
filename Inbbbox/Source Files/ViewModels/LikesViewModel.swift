//
//  LikesViewModel.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 29.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit


class LikesViewModel: BaseCollectionViewViewModel {
    
    var delegate: BaseCollectionViewViewModelDelegate?
    let title = NSLocalizedString("Likes", comment:"")
    var likedShots = [ShotType]()
    private let shotsProvider = ShotsProvider()
    private var userMode: UserMode
    
    var itemsCount: Int {
        return likedShots.count
    }
    
    init() {
        userMode = UserStorage.isUserSignedIn ? .LoggedUser : .DemoUser
    }
    
    func downloadInitialItems() {
        firstly {
            shotsProvider.provideMyLikedShots()
        }.then { shots -> Void in
            if let shots = shots where shots != self.likedShots || shots.count == 0 {
                self.likedShots = shots
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
            if let shots = shots where shots.count > 0 {
                let indexes = shots.enumerate().map { index, _ in
                    return index + self.likedShots.count
                }
                self.likedShots.appendContentsOf(shots)
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
    
    func shotCollectionViewCellViewData(indexPath: NSIndexPath) -> (imageURL: NSURL, animated: Bool) {
        let imageURL = likedShots[indexPath.row].shotImage.normalURL
        let animated = likedShots[indexPath.row].animated
        return (imageURL, animated)
    }
    
    func clearViewModelIfNeeded() {
        let currentUserMode = UserStorage.isUserSignedIn ? UserMode.LoggedUser : .DemoUser
        if userMode != currentUserMode {
            likedShots = []
            userMode = currentUserMode
            delegate?.viewModelDidLoadInitialItems()
        }
    }
}
