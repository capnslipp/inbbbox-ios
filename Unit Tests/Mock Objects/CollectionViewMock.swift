//
// Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Dobby

@testable import Inbbbox

class CollectionViewMock: UICollectionView {

    let numberOfItemsInSectionStub = Stub<Int, Int>()

    override func numberOfItemsInSection(section: Int) -> Int {
        return try! numberOfItemsInSectionStub.invoke(section)
    }
}
