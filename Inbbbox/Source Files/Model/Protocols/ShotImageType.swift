//
//  ShotImageType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/17/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ShotImageType {
    var hidpiURL: NSURL? { get }
    var normalURL: NSURL { get }
    var teaserURL: NSURL { get }
}