//
//  ImageProvider.swift
//  Inbbbox
//
//  Created by Peter Bruz on 11/04/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Haneke

final class ImageProvider {
    
    /// Lazily loads images from URLs
    ///
    /// - parameter urls:                  Tuple consisting of max 3 urls that are loaded one by one.
    /// - parameter teaserImageCompletion: Completion called after downloading teaser image.
    /// - parameter normalImageCompletion: Completion called after downloading normal image.
    /// - parameter hidpiImageCompletion:  Completion called after downloading hidpi image.
    class func lazyLoadImageFromURLs(urls: (teaserURL: NSURL, normalURL: NSURL?, hidpiURL: NSURL?), teaserImageCompletion: UIImage -> Void, normalImageCompletion: (UIImage -> Void)?, hidpiImageCompletion: (UIImage -> Void)?) {
        
        loadImageFromURL(urls.teaserURL) { teaserImage in
            teaserImageCompletion(teaserImage)
            
            if let normalURL = urls.normalURL {
                loadImageFromURL(normalURL) { normalImage in
                    normalImageCompletion?(normalImage)
                    print("normal loaded for \(normalURL.absoluteString)")
                    if let hidpiURL = urls.hidpiURL {
                        loadImageFromURL(hidpiURL) { hidpiImage in
                            print("hidpi loaded for \(hidpiURL.absoluteString)")
                            hidpiImageCompletion?(hidpiImage)
                        }
                    }
                }
            }
        }
    }
    
    /// Loads image from URL
    ///
    /// - parameter url:        URL where image is located
    /// - parameter completion: Complation that contains downloaded image.
    class func loadImageFromURL(url: NSURL, completion: UIImage -> Void) {
        Shared.imageCache.fetch(URL: url, formatName: CacheManager.imageFormatName, failure: nil, success: { image in
            completion(image)
            }
        )
    }
}
