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

    var isCurrentLayoutOneColumn: Bool {
        get {
            return collectionView!.collectionViewLayout.isKindOfClass(OneColumnCollectionViewFlowLayout)
        }
    }

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
        collectionView.backgroundColor = UIColor.backgroundGrayColor()
        setupBarButtons()
        updateBarButtons(collectionView.collectionViewLayout)
    }

    // MARK: Configuration

    func setupBarButtons() {
        oneColumnLayoutButton = UIBarButtonItem(image: UIImage(named: "ic-listview"), style: .Plain, target: self, action: #selector(didTapOneColumnLayoutButton(_:)))
        twoColumnsLayoutButton = UIBarButtonItem(image: UIImage(named: "ic-gridview-active"), style: .Plain, target: self, action: #selector(didTapTwoColumnsLayoutButton(_:)))
        navigationItem.rightBarButtonItems = [oneColumnLayoutButton!, twoColumnsLayoutButton!]
    }

    func updateBarButtons(layout: UICollectionViewLayout) {
        oneColumnLayoutButton?.tintColor = !isCurrentLayoutOneColumn ? UIColor.whiteColor().colorWithAlphaComponent(0.35) : UIColor.whiteColor()
        twoColumnsLayoutButton?.tintColor = isCurrentLayoutOneColumn ? UIColor.whiteColor().colorWithAlphaComponent(0.35) : UIColor.whiteColor()
    }

    // MARK: Actions:

    func didTapOneColumnLayoutButton(_: UIBarButtonItem) {
        if !isCurrentLayoutOneColumn {
            changeLayout()
        }
    }

    func didTapTwoColumnsLayoutButton(_: UIBarButtonItem) {
        if isCurrentLayoutOneColumn {
            changeLayout()
        }
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
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
        }
    }
}
