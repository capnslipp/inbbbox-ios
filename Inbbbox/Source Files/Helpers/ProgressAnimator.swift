//
//  ProgressAnimator.swift
//  Inbbbox
//
//  Created by Kamil Tomaszewski on 25/05/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class ProgressAnimator {

    var progressImageView = UIImageView()

    private var baseName: String
    private var maximumImageCount: Int

    // MARK: Public

    /// Default initializer
    ///
    /// - parameter imageBaseName:     Common part of files' names with separator i.e loadgif_
    /// - parameter imageCount:     Number of files that should become the animation.
    ///
    /// - returns: instance of ProgressAnimator
    init(imageBaseName: String, imageCount: Int) {
        baseName = imageBaseName
        maximumImageCount = imageCount
    }

    /// Updates progress of animation according to passed value
    ///
    /// - parameter progress:     Progress value between 0.0 - 1.0. If you pass higher value than 1.0 it will be 
    //                            locked to 1.0 value
    func updateProgress(progress: Float) {
        progressImageView.image = image(min(1.0, progress))
    }

    //MARK: Private

    private func interpolateProgress(progress: Float) -> Int {
        let maximum = Float(maximumImageCount)
        let animationFrameKey = maximum * progress
        return Int(animationFrameKey)
    }

    private func imageName(progress: Float) -> String {
        return baseName + String(interpolateProgress(progress))
    }

    private func image(progress: Float) -> UIImage? {
        return UIImage(named: imageName(progress))
    }
}
