//
//  UIImageViewExtension.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 07.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Haneke

extension UIImageView {
    
    func loadImageFromURL(url: NSURL, placeholderImage: UIImage? = nil) {
        image = placeholderImage
        Shared.imageCache.fetch(URL: url, formatName: CacheManager.imageFormatName, failure: nil, success: {[weak self] image in
                self?.image = image
            })
    }
}
