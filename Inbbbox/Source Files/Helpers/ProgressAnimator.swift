//
//  ProgressAnimator.swift
//  Inbbbox
//
//  Created by Kamil Tomaszewski on 25/05/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class ProgressAnimator {

    private var baseName: String

    var progressImageView = UIImageView()

    init(imageBaseName: String) {
        baseName = imageBaseName
    }

    private func interpolateProgress(progress: Float) -> Int {
        let maximum = Float(59)
        let animationFrameKey = maximum * progress
        return Int(animationFrameKey)
    }

    private func imageName(progress: Float) -> String {
        return baseName + String(interpolateProgress(progress))
    }

    private func image(progress: Float) -> UIImage? {
        return UIImage(named: imageName(progress))
    }

    func updateProgress(progress: Float) {
        progressImageView.image = image(progress)
    }
}
