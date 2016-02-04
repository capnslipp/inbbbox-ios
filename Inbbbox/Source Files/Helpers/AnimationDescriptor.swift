//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

struct AnimationDescriptor {

    enum AnimationType {
        case Plain
        case Spring
    }

    var animationType = AnimationType.Plain
    var duration = 0.3
    var delay = 0.0
    var springDamping = CGFloat(0.6)
    var springVelocity = CGFloat(0.9)
    var options: UIViewAnimationOptions = []
    var animations = {}
    var completion: ((Bool) -> Void)?
}
