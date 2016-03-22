//
//  ShotsStateHandler.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 3/22/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ShotsStateHandlerDelegate: class {
    func cellDidInvokeLikeAction()
    func cellDidInvokeAddToBucketAction()
    func cellDidInvokeCommentAction()
}

protocol ShotsStateHandler {
    weak var delegate: ShotsStateHandlerDelegate? {get set}

    var collectionViewLayout: UICollectionViewLayout { get }

    func itemsCountForShots(shots: [ShotType], collectionView: UICollectionView, section: Int) -> Int

    func cellForShots(shots: [ShotType], collectionView: UICollectionView, indexPath: NSIndexPath) -> ShotCollectionViewCell
}
