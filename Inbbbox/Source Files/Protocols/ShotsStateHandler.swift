//
//  ShotsStateHandler.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 3/22/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ShotsStateHandlerDelegate: class {
    func shotsStateHandlerDidInvalidate(shotsStateHandler: ShotsStateHandler)
}

protocol ShotsStateHandler {

    weak var delegate: ShotsStateHandlerDelegate? { get set }

    var state: ShotsCollectionViewController.State { get }

    var nextState: ShotsCollectionViewController.State? { get }

    var collectionViewLayout: UICollectionViewLayout { get }

    var tabBarInteractionEnabled: Bool { get }

    var collectionViewInteractionEnabled: Bool { get }

    func numberOfItems(shotsCollectionViewController: ShotsCollectionViewController, collectionView: UICollectionView, section: Int) -> Int

    func configuredCell(shotsCollectionViewController: ShotsCollectionViewController, collectionView: UICollectionView, indexPath: NSIndexPath) -> ShotCollectionViewCell

    func didSelectItem(shotsCollectionViewController: ShotsCollectionViewController, collectionView: UICollectionView, indexPath: NSIndexPath)

    func willDisplayCell(shotsCollectionViewController: ShotsCollectionViewController, collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: NSIndexPath)
}
