//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol PresentationStepDelegate: class {
    func presentationStepDidFinish(presentationStep: PresentationStep)
}

protocol PresentationStep: class {
    weak var presentationStepDelegate: PresentationStepDelegate? { get set }
    var presentationStepViewController: PresentationStepViewController { get }
}
