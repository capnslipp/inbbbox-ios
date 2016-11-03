//
//  FlashMessageView.swift
//  Inbbbox
//
//  Created by Blazej Wdowikowski on 10/24/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

struct FlashMessageViewModel {
    let title: String
    let duration: FlashMessageDuration
    
    init(title: String, duration: FlashMessageDuration = .Automatic){
        self.title = title
        self.duration = duration
    }
}
