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

    private let baseName: String!
    private let maximumImageCount: Int!
    private var currentFrameLimit = 0
    private var currentFrame = 0
    private var frameDuration = 0.01
    private var firstFireToken = 0
    private var onDidCompleateAnimation: (()->Void)?
    private var timer: NSTimer!
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
        timer = NSTimer.scheduledTimerWithTimeInterval(frameDuration, target: self, selector: #selector(self.updateFrame), userInfo: nil, repeats: true)
    }

    /// Updates progress of animation according to passed value
    ///
    /// - parameter progress:     Progress value between 0.0 - 1.0. If you pass higher value than 1.0 it will be
    //                            locked to 1.0 value
    func updateProgress(progress: Float, onComplete complete: (()->Void)? = nil) {
        
        
        let newFrameLimit = interpolateProgress(min(1.0, progress))
        guard currentFrameLimit < newFrameLimit  else {
            return
        }
        
        currentFrameLimit = newFrameLimit
        onDidCompleateAnimation = complete
        if !timer.valid && currentFrame < maximumImageCount  {
            timer = NSTimer.scheduledTimerWithTimeInterval(frameDuration, target: self, selector: #selector(self.updateFrame), userInfo: nil, repeats: true)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

private extension ProgressAnimator {
    
    @objc func updateFrame() {
        guard currentFrame <= currentFrameLimit && isFrameInBounds() else {
            timer.invalidate()
            return
        }
        
        progressImageView.image = image(currentFrame)
        currentFrame += 1
        
        if !isFrameInBounds() {
            onDidCompleateAnimation?()
        }
    }
    
    func isFrameInBounds() -> Bool {
        return currentFrame <= maximumImageCount
    }
    
    func interpolateProgress(progress: Float) -> Int {
        let maximum = Float(maximumImageCount)
        let animationFrameKey = maximum * progress
        return Int(animationFrameKey)
    }
    
    func imageName(frameIndex: Int) -> String {
        return baseName + String(frameIndex)
    }
    
    func image(frameIndex: Int) -> UIImage? {
        return UIImage(named: imageName(frameIndex))
    }
}
