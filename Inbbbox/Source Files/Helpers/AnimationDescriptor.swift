//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum AnimationType {
    case Plain
    case Spring
}

protocol AnimationDescriptor {

    var animationType: AnimationType {get set}
    var duration: NSTimeInterval {get set}
    var delay: NSTimeInterval {get set}
    var springDamping: CGFloat {get set}
    var springVelocity: CGFloat {get set}
    var options: UIViewAnimationOptions {get set}
    var animations: () -> Void {get set}
    var completion: ((Bool) -> Void)? {get set}
}
