//
//  ShotImageType.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/17/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ShotImageType {

    /**
     The hidpi image may or may not be present, but will always be 800x600

     - returns: URL to image with size 800x600
    */
    var hidpiURL: NSURL? { get }

    /**
     The normal image is typically 400x300, but may be smaller if created before October 4th, 2012

     - returns: URL to image with size 400x300
    */
    var normalURL: NSURL { get }

    /**
     The teaser image is typically 200x150, but may be smaller if created before October 4th, 2012

     - returns: URL to image with size 200x150
    */
    var teaserURL: NSURL { get }
}
