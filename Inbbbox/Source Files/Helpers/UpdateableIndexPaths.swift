//
//  UpdateableIndexPaths.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 12.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct UpdateableIndexPaths {

    enum UpdateStatus {
        case NotStarted
        case InProgress
        case Updated
    }

    let indexPath: NSIndexPath
    var status: UpdateStatus = .NotStarted

    init(indexPath: NSIndexPath) {
        self.indexPath = indexPath
    }
}

func ==(lhs: UpdateableIndexPaths, rhs: UpdateableIndexPaths) -> Bool {
    return lhs.indexPath == rhs.indexPath
}
