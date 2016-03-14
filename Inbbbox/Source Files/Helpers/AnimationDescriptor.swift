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
    var duration: NSTimeInterval {get}
    var delay: NSTimeInterval {get set}
    var springDamping: CGFloat {get}
    var springVelocity: CGFloat {get}
    var options: UIViewAnimationOptions {get set}
    var animations: () -> Void {get set}
    var completion: ((Bool) -> Void)? {get set}
    
    init(shotCell: ShotCollectionViewCell, swipeCompletion: (() -> ())?)
}

extension AnimationDescriptor {
    var springDamping: CGFloat {
        return 0.0
    }
    var springVelocity: CGFloat {
        return 0.0
    }
    var duration: NSTimeInterval {
        return 0.3
    }
}
