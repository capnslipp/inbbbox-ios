//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol AnimationStepDelegate: class {

    func animationStepDidFinish(animationStep: AnimationStep)
}

protocol AnimationStep {

    weak var delegate: AnimationStepDelegate? {get set}
    func animate()
}
