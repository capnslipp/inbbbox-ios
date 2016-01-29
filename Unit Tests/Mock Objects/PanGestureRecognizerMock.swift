//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Dobby

@testable import Inbbbox

class PanGestureRecognizerMock: UIPanGestureRecognizer {

    let velocityInViewStub = Stub<UIView?, CGPoint>()

    override func velocityInView(view: UIView?) -> CGPoint {
        return try! velocityInViewStub.invoke(view)
    }
}
