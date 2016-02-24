//
//  ImageMock.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/11/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Dobby

@testable import Inbbbox

class ImageMock: UIImage {

    static let cachedImageFromURLStub = Stub<(NSURL, UIImage?), UIImage?>()
    let blurredImageStub = Stub<CGFloat, UIImage>()

    override func imageByBlurringImageWithBlur(blur: CGFloat) -> UIImage {
        return try! blurredImageStub.invoke(blur)
    }
}
