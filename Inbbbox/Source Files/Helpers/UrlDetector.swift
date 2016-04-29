//
//  UrlDetector.swift
//  Inbbbox
//
//  Created by Peter Bruz on 28/04/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class UrlDetector {
    class func detectUrlFromGestureRecognizer(gestureRecognizer: UIGestureRecognizer,
                                              textContainer: NSTextContainer,
                                              layoutManager: NSLayoutManager) -> NSURL? {

        guard let view = gestureRecognizer.view else { return nil }

        var locationOfTouchInLabel = gestureRecognizer.locationInView(gestureRecognizer.view)
        let glyphRange = layoutManager.glyphRangeForTextContainer(textContainer)

        let textOffset: CGPoint = {
            var textOffset = CGPoint.zero
            let textBounds = layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer)
            let paddingHeight = (view.bounds.size.height - textBounds.size.height) / 2
            if paddingHeight > 0 {
                textOffset.y = paddingHeight
            }
            return textOffset
        }()

        locationOfTouchInLabel.x -= textOffset.x
        locationOfTouchInLabel.y -= textOffset.y

        let glyphIndex = layoutManager.glyphIndexForPoint(locationOfTouchInLabel, inTextContainer: textContainer)
        let locationIndex = layoutManager.characterIndexForGlyphAtIndex(glyphIndex)

        return (view as? UILabel)?.attributedText?.attribute(NSLinkAttributeName,
                                                             atIndex: locationIndex, effectiveRange: nil) as? NSURL
    }
}
