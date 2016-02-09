//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIView {
    
    class func animateWithDescriptor(animationDescriptor: AnimationDescriptor) {
        let duration = animationDescriptor.duration
        let delay = animationDescriptor.delay
        let options = animationDescriptor.options
        let animationType = animationDescriptor.animationType
        let animations = animationDescriptor.animations
        let completion = animationDescriptor.completion
        
        switch animationType {
        case AnimationType.Plain:
            self.animateWithDuration(duration,
                delay: delay,
                options: options,
                animations: animations,
                completion: completion)
        case AnimationType.Spring:
            let springDamping = animationDescriptor.springDamping
            let springVelocity = animationDescriptor.springVelocity
            self.animateWithDuration(duration,
                delay: delay,
                usingSpringWithDamping: springDamping,
                initialSpringVelocity: springVelocity,
                options: options,
                animations: animations,
                completion: completion)
        }
    }
}
