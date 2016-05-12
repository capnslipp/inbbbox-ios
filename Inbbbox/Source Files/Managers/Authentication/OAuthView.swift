//
//  OAuthView.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import WebKit
import PureLayout

final class OAuthView: UIView {

    let webView: WKWebView
    let back: UIBarButtonItem
    let forward: UIBarButtonItem
    private let toolbar = UIToolbar.newAutoLayoutView()
    private var didSetConstraints = false

    override init(frame: CGRect) {

        let configuration = WKWebViewConfiguration()
        configuration.preferences = {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = false

            return preferences
        }()

        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.backgroundColor = .grayColor()
        webView.allowsBackForwardNavigationGestures = true

        back = UIBarButtonItem(image: UIImage(named: "ic-back"), style: .Plain, target: nil, action: nil)
        back.enabled = false

        forward = UIBarButtonItem(image: UIImage(named: "ic-forward"), style: .Plain, target: nil, action: nil)
        forward.enabled = false

        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)

        toolbar.setItems([space, back, space, forward, space], animated: true)
        toolbar.barStyle = .Default
        toolbar.tintColor = .whiteColor()
        toolbar.barTintColor = .pinkColor()

        super.init(frame: frame)

        addSubview(webView)
        addSubview(toolbar)
        backgroundColor = .whiteColor()
    }

    @available(*, unavailable, message="Use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {

        if !didSetConstraints {
            didSetConstraints = true

            webView.autoPinEdgesToSuperviewEdges()
            toolbar.autoPinEdgeToSuperviewEdge(.Leading)
            toolbar.autoPinEdgeToSuperviewEdge(.Trailing)
            toolbar.autoPinEdgeToSuperviewEdge(.Bottom)
        }

        super.updateConstraints()
    }
}
