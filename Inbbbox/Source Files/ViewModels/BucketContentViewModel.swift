//
//  BucketContentViewModel.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 15.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

import Foundation
import PromiseKit


class BucketContentViewModel: BaseCollectionViewViewModel {
    
    var delegate: BaseCollectionViewViewModelDelegate?
    var shots = [ShotType]()
    private let shotsProvider = ShotsProvider()
    private var userMode: UserMode
    private var bucket: BucketType
    
    var itemsCount: Int {
        return shots.count
    }
    
    var title: String {
        return bucket.name
    }
    
    init(bucket: BucketType) {
        userMode = UserStorage.isUserSignedIn ? .LoggedUser : .DemoUser
        self.bucket = bucket
    }
    
    func downloadInitialItems() {
        firstly {
            shotsProvider.provideShotsForBucket(self.bucket)
        }.then { shots -> Void in
            if let shots = shots where shots != self.shots {
                self.shots = shots
            }
            self.delegate?.viewModelDidLoadInitialItems()
        }.error { error in
            // NGRTemp: Need mockups for error message view
            print(error)
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
                    return index + self.shots.count
                }
                self.shots.appendContentsOf(shots)
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
        let imageURL = shots[indexPath.row].shotImage.normalURL
        let animated = shots[indexPath.row].animated
        return (imageURL, animated)
    }
    
    func clearViewModelIfNeeded() {
        let currentUserMode = UserStorage.isUserSignedIn ? UserMode.LoggedUser : .DemoUser
        if userMode != currentUserMode {
            shots = []
            userMode = currentUserMode
            delegate?.viewModelDidLoadInitialItems()
        }
    }
}
