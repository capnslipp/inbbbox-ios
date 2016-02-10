//
//  UIImageExtension.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/10/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import GPUImage

extension UIImage {
    
    class func cachedImageFromURL(url: NSURL, placeholderImage: UIImage? = nil) -> UIImage? {
        let imageView = UIImageView()
        imageView.loadImageFromURL(url, placeholderImage: placeholderImage)
        return imageView.image
    }
    
    func blurredImage(blur: CGFloat) -> UIImage {
        let maxBlurRadius = CGFloat(5)
        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = blur * maxBlurRadius
        return blurFilter.imageByFilteringImage(self)
    }
}