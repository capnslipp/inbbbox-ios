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
    private var likedShots = [ShotType]()
    private let shotsProvider = ShotsProvider()
    
    var itemsCount: Int {
        return likedShots.count
    }
    
    func downloadInitialItems() {
        firstly {
            shotsProvider.provideLikedShotsForUser(UserStorage.currentUser!)
        }.then { shots -> Void in
            if let shots = shots {
                self.likedShots = shots
                self.delegate?.viewModelDidLoadInitialItems(self)
            }
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
        }
    }
    
    func downloadItemsForNextPage() {
        guard UserStorage.currentUser != nil else {
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
}
