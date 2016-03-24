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

protocol ShotsStateHandler: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {

    weak var shotsCollectionViewController: ShotsCollectionViewController? { get set }

    weak var delegate: ShotsStateHandlerDelegate? { get set }

    var state: ShotsCollectionViewController.State { get }

    var nextState: ShotsCollectionViewController.State? { get }

    var collectionViewLayout: UICollectionViewLayout { get }

    var tabBarInteractionEnabled: Bool { get }

    var collectionViewInteractionEnabled: Bool { get }
    
    var colletionViewScrollEnabled: Bool { get }
    
    func presentData()
}
