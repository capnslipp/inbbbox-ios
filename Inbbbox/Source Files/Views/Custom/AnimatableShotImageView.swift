//
//  AnimatableShotImageView.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 02.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout
import Gifu
import Haneke
import Async

class AnimatableShotImageView: AnimatableImageView {
    let downloader = DataDownloader()
    private let progressView = UIProgressView.newAutoLayoutView()
    private var didSetupConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .cellBackgroundColor()
        contentMode = .ScaleAspectFill
        progressView.progressViewStyle = .Bar
        progressView.trackTintColor = .cellBackgroundColor()
        progressView.progressTintColor = .pinkColor()
        progressView.setProgress(0, animated: false)
        addSubview(progressView)
    }
    
    @available(*, unavailable, message="Use init(frame:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            didSetupConstraints = true

            progressView.autoAlignAxisToSuperviewAxis(.Horizontal)
            let progressInset = CGFloat(10)
            progressView.autoPinEdgeToSuperviewEdge(.Leading, withInset: progressInset)
            progressView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: progressInset)
        }
        
        super.updateConstraints()
    }
    
    func loadAnimatableShotFromUrl(url: NSURL) {
        Shared.dataCache.fetch(key: url.absoluteString, failure: { _ in
            self.fetchWithURL(url)
        }, success: { data in
            self.setImageWithData(data)
        })
    }
    
    private func fetchWithURL(url: NSURL) {
        downloader.fetchData(url, progress: { [weak self] progress in
            self?.updateWithProgress(progress)
        }) { [weak self] data in
            self?.setImageWithData(data)
            Shared.dataCache.set(value: data, key: url.absoluteString, formatName: CacheManager.gifFormatName, success: nil)
        }
    }
    
    private func setImageWithData(data: NSData) {
        Async.main {
            self.progressView.hidden = true
            self.animateWithImageData(data)
        }
    }
    
    private func updateWithProgress(progress: Float) {
        Async.main {
            self.progressView.setProgress(progress, animated: true)
        }
    }
}

