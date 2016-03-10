//
//  BaseCollectionViewViewModel.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 26.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol BaseCollectionViewViewModel {
    
    var delegate: BaseCollectionViewViewModelDelegate? { get }
    var itemsCount: Int { get }
    
    func downloadInitialItems()
    func downloadItemsForNextPage()
    
}

protocol BaseCollectionViewViewModelDelegate {
    
    func viewModelDidLoadInitialItems()
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadItemsAtIndexPaths indexPaths: [NSIndexPath])
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath)
}

extension BaseCollectionViewViewModelDelegate {
    
    func viewModel(viewModel: BaseCollectionViewViewModel, didLoadShotsForItemAtIndexPath indexPath: NSIndexPath) {
        // Empty by design - optional function.
    }
}
