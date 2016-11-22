//
//  ImageViewerExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 15/04/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import ImageViewer

class ImageViewer: GalleryViewController {

    /// Initialize `ImageViewer` using default configuration.
    ///
    /// - parameter imageDataSource: Object that conforms to protocol `GalleryItemsDatasource`.
    /// - parameter displacedView: View that should be displaced.
    init(imageDataSource: GalleryItemsDatasource, displacedView: UIView) {

        /*let closeImage = UIImage(named: "ic-cross-naked") ?? UIImage()

        let buttonAssets = CloseButtonAssets(normal: closeImage, highlighted: closeImage)
        let imageSize = CGSize(width: 40, height: 40)
        let configuration = ImageViewerConfiguration(imageSize: imageSize, closeButtonAssets: buttonAssets)*/
        super.init(startIndex: 0, itemsDatasource: imageDataSource)
    }

    /// Initialize `ImageViewer` using default configuration for animated urls
    ///
    /// - parameter imageProvider: Object that conforms to protocol `ImageProvider`.
    /// - parameter displacedView: View that should be displaced.
    /// - parameter animatedUrl: Url with animated gif image
    init(imageDataSource: GalleryItemsDatasource, displacedView: UIView, animatedUrl: NSURL) {

        /*self.init(imageProvider: imageProvider, displacedView: displacedView)

        let animatableImageView = AnimatableShotImageView(frame: CGRect.zero)
        animatableImageView.backgroundColor = .clearColor()
        animatableImageView.loadAnimatableShotFromUrl(animatedUrl)

        self.imageView = animatableImageView*/
        super.init(startIndex: 0, itemsDatasource: imageDataSource)
    }
}
