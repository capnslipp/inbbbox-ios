//
//  FlashMessageView.swift
//  Inbbbox
//
//  Created by Blazej Wdowikowski on 10/24/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

struct FlashMessageViewModel {
    let title:String
    let durration:FlashMessageDuration
    
    init(title:String, durration:FlashMessageDuration = .Automatic){
        self.title = title
        self.durration = durration
    }
}
