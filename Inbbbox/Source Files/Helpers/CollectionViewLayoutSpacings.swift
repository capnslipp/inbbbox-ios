//
//  CollectionViewLayoutSpacings.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 28.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

struct CollectionViewLayoutSpacings {

    // MARK: General

    let shotHeightToWidthRatio = CGFloat(0.75)

    // MARK: One Column Layout Specific

    let itemMargin = CGFloat(28)
    let sectionMarginHorizontal = CGFloat(28)
    let sectionMarginVertical = CGFloat(30)
    let minimumLineSpacing = CGFloat(29)
    let initialShotsLayoutBottomCellOffset = CGFloat(40)

    // MARK: Two Columns Layout Specific

    let twoColumnsItemMargin = CGFloat(25)
    let twoColumnsSectionMarginHorizontal = CGFloat(30)
    let twoColumnsSectionMarginVertical = CGFloat(25)
    let twoColumnsMinimumLineSpacing = CGFloat(19)
    let twoColumnsMinimymInterimSpacing = CGFloat(25)
}
