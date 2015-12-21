//
//  OAuthViewController.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import WebKit
import PromiseKit

final class OAuthViewController: UIViewController {
    
    private let KeyPathForObservingProgress = "estimatedProgress"
    private let viewModel: OAuthViewModel
    private let silentAuthenticationFailureHandler: (UIViewController -> Void)
    
    private var progressView: UIProgressView?
    private weak var aView: OAuthView?
    
    init(oAuthAuthorizableService: OAuthAuthorizable, silentAuthenticationFailureHandler: (UIViewController -> Void)) {
        viewModel = OAuthViewModel(oAuthAuthorizableService: oAuthAuthorizableService)
        self.silentAuthenticationFailureHandler = silentAuthenticationFailureHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        aView = loadViewWithClass(OAuthView.self)
        aView?.webView.navigationDelegate = self
        aView?.webView.addObserver(self, forKeyPath: KeyPathForObservingProgress, options: .New, context: nil)
        
        viewModel.loadRequestReverseClosure = { [weak self] request in
            self?.aView?.webView.loadRequest(request)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        progressView = navigationController?.progressViewByEmbedingInNavigationBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .Plain, target: self, action: "cancelBarButtonDidTap:")
    }
    
    deinit {
        aView?.webView.removeObserver(self, forKeyPath: KeyPathForObservingProgress)
    }
    
    func startAuthentication() -> Promise<String> {
        
        forceViewToLoadIfNeeded()
        return Promise { fulfill, reject in
            
            firstly {
                viewModel.startAuthentication()
            }.then { accessToken -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                fulfill(accessToken)
            }.error { error in
                reject(error)
            }
        }
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == KeyPathForObservingProgress {
            progressView?.progress = Float(aView?.webView.estimatedProgress ?? 0)
            if progressView?.progress >= 1 {
                progressView?.hidden = true
            }
        }
    }
    
    //MARK: Actions
    
    func cancelBarButtonDidTap(_: UIBarButtonItem) {
        viewModel.currentResolvers?.reject(AuthenticatorError.AuthenticationDidCancel)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension OAuthViewController: WKNavigationDelegate {
    
    func webView(webView: WKWebView,didStartProvisionalNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView,didFinishNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if !viewModel.service.isSilentAuthenticationURL(navigationAction.request.URL) {
            silentAuthenticationFailureHandler(self)
        }
        
        let policy = viewModel.actionPolicyForRequest(navigationAction.request)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = (policy == .Allow)
        decisionHandler(policy)
    }
}

private extension OAuthViewController {
    
    /**
     Force to load view if not present.
     
     @discussion: 
     Apple docs says to not call loadView method directly.
     Instead of that load or create a view by calling view property.
     */
    func forceViewToLoadIfNeeded() {
        if !isViewLoaded() {
            let _ = view
        }
    }
}
