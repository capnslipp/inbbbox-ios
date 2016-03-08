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
    
    func loadImageFromURLString(urlString: String, placeholderImage:UIImage? = nil) {
        image = placeholderImage
        if let url = NSURL(string: urlString) {
            loadImageFromURL(url)
        }
    }
    
    func loadImageFromURL(url: NSURL) {
        Shared.imageCache.fetch(URL: url, formatName: CacheManager.imageFormatName, failure: nil, success: {[weak self] image in
                self?.image = image
            })
    }
}
