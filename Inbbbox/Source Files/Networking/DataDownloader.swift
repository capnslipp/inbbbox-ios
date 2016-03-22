//
//  DataDownloader.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 18.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class DataDownloader: NSObject {
    private var data = NSMutableData()
    private var totalSize = Float(0)
    private var progress:((Float) -> Void)?
    private var completion:((NSData) -> Void)?
    
    func fetchData(url: NSURL, progress:(progress: Float) -> Void, completion:(data: NSData) -> Void) {
        self.progress = progress
        self.completion = completion
        let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithURL(url)
        
        task.resume()
    }
}

extension DataDownloader: NSURLSessionDataDelegate {
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse,
        completionHandler: (NSURLSessionResponseDisposition) -> Void) {
            completionHandler(.Allow)
            totalSize = Float(response.expectedContentLength)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data)
        let progress = Float(self.data.length) / totalSize
        if progress != 1 {
            if self.progress != nil {
                self.progress!(progress)
                return
            }
        }
        if let completion = self.completion {
            completion(NSData(data: self.data))
        }
    }
}