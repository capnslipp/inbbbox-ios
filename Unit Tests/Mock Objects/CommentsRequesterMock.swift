//
//  CommentsRequesterMock.swift
//  Inbbbox
//
//  Created by Peter Bruz on 23/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Dobby
import PromiseKit

@testable import Inbbbox

class CommentsRequesterMock: CommentsRequester {
    
    let postCommentForShotStub = Stub<(Shot, String), Promise<Comment>>()
    
    override func postCommentForShot(shot: Shot, withText text: String) -> Promise<Comment> {
        return try! postCommentForShotStub.invoke(shot, text)
    }
}
