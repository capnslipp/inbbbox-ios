//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class AnimationContainerViewController: UIViewController {

    private(set) var animationSteps: [AnimationStep]
    
    @available(*, unavailable, message = "Use init(animationSteps:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(animationSteps animationSteps: [AnimationStep]) {
        self.animationSteps = animationSteps
        super.init(nibName: nil, bundle: nil)
    }
}
