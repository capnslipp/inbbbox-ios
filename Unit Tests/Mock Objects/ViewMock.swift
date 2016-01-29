//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Dobby

@testable import Inbbbox

class ViewMock: UIView {

    static let springAnimationStub = Stub<(NSTimeInterval, NSTimeInterval, CGFloat, CGFloat, UIViewAnimationOptions, () -> Void, ((Bool) -> Void)?), Void>()

    override class func animateWithDuration(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
        try! springAnimationStub.invoke(duration, delay, dampingRatio, velocity, options, animations, completion)
    }
}
