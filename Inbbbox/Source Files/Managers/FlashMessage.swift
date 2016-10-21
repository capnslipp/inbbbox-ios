//
// Created by Blazej Wdowikowski on 21/10/2016.
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PureLayout

class FlashMessage {

    private static let shared = FlashMessage()

    static func show(message message:String) {
        guard let rootView = UIApplication.sharedApplication().keyWindow?.rootViewController?.view else {
            return
        }
        
        let f = FlashMessageView()
        f.message = message
        rootView.addSubview(f)
        f.autoPinEdgeToSuperviewEdge(.Left)
        f.autoPinEdgeToSuperviewEdge(.Right)
        f.autoPinEdgeToSuperviewEdge(.Top,withInset: 20)
        f.autoSetDimension(.Height, toSize: 84)
    }
}
