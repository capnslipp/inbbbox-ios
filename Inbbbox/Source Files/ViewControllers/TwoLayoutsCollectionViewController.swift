//
//  TwoLayoutsCollectionViewController.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 28.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class TwoLayoutsCollectionViewController: UICollectionViewController {

    // MARK: - Lifecycle
    
    var oneColumnLayoutCellHeightToWidthRatio = CGFloat(1)
    var twoColumnsLayoutCellHeightToWidthRatio = CGFloat(1)
    private var oneColumnLayoutButton: UIBarButtonItem?
    private var twoColumnsLayoutButton: UIBarButtonItem?
    
    convenience init(oneColumnLayoutCellHeightToWidthRatio: CGFloat, twoColumnsLayoutCellHeightToWidthRatio: CGFloat) {
        let flowLayout = TwoColumnsCollectionViewFlowLayout()
        flowLayout.itemHeightToWidthRatio = twoColumnsLayoutCellHeightToWidthRatio
        self.init(collectionViewLayout: flowLayout)
        self.oneColumnLayoutCellHeightToWidthRatio = oneColumnLayoutCellHeightToWidthRatio
        self.twoColumnsLayoutCellHeightToWidthRatio = twoColumnsLayoutCellHeightToWidthRatio
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = UIColor.whiteColor()
        setupBarButtons()
        updateBarButtons(collectionView.collectionViewLayout)
    }
    
    // MARK: Configuration
    
    func setupBarButtons() {
        // NGRTodo: set images instead of title
        oneColumnLayoutButton = UIBarButtonItem(title: "1", style: .Plain, target: self, action: "didTapOneColumnLayoutButton:")
        twoColumnsLayoutButton = UIBarButtonItem(title: "2", style: .Plain, target: self, action: "didTapTwoColumnsLayoutButton:")
        navigationItem.rightBarButtonItems = [oneColumnLayoutButton!, twoColumnsLayoutButton!]
    }
    
    func updateBarButtons(layout: UICollectionViewLayout) {
        let isCurrentLayoutOneColumn = layout.isKindOfClass(OneColumnCollectionViewFlowLayout)
        oneColumnLayoutButton?.enabled = !isCurrentLayoutOneColumn
        twoColumnsLayoutButton?.enabled = isCurrentLayoutOneColumn
    }
    
    // MARK: Actions:
    
    func didTapOneColumnLayoutButton(_: UIBarButtonItem) {
        changeLayout()
    }
    
    func didTapTwoColumnsLayoutButton(_: UIBarButtonItem) {
        changeLayout()
    }
    
    // Mark: Changing layout 
    
    func changeLayout() {
        guard let collectionView = collectionView else {
            return
        }
        if collectionView.collectionViewLayout.isKindOfClass(OneColumnCollectionViewFlowLayout) {
            let flowLayout = TwoColumnsCollectionViewFlowLayout()
            flowLayout.itemHeightToWidthRatio = twoColumnsLayoutCellHeightToWidthRatio
            collectionView.setCollectionViewLayout(flowLayout, animated: false)
        } else {
            let flowLayout = OneColumnCollectionViewFlowLayout()
            flowLayout.itemHeightToWidthRatio = oneColumnLayoutCellHeightToWidthRatio
            collectionView.setCollectionViewLayout(flowLayout, animated: false)
        }
        collectionView.reloadData()
        scrollToTop(collectionView)
        updateBarButtons(collectionView.collectionViewLayout)
    }
    
    func scrollToTop(collectionView: UICollectionView) {
        if (collectionView.numberOfItemsInSection(0) > 0) {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
        }
    }
}
