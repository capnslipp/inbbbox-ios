//
//  Image.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 19.04.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol DefaultImage {
    var defaultImage: UIImage { get }
}

extension DefaultImage {
    var defaultImage: UIImage {
        return UIImage(named: "ic-ball-loader")!
    }
}
