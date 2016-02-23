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

    func imageByBlurringImageWithBlur(blur: CGFloat) -> UIImage {
        let maxBlurRadius = CGFloat(1)
        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = blur * maxBlurRadius
        
        return blurFilter.imageByFilteringImage(self)
    }
}
