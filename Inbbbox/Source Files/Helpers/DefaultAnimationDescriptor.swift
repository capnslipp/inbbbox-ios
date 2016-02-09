//
//  DefaultAnimationDescriptor.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/8/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

struct DefaultAnimationDescriptor: AnimationDescriptor {

    var animationType = AnimationType.Plain
    var duration = 0.3
    var delay = 0.0
    var springDamping = CGFloat(0.6)
    var springVelocity = CGFloat(0.9)
    var options: UIViewAnimationOptions = []
    var animations = {}
    var completion: ((Bool) -> Void)?
}
