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

class APICommentsRequesterMock: APICommentsRequester {
    
    let postCommentForShotStub = Stub<(ShotType, String), Promise<CommentType>>()
    
    override func postCommentForShot(shot: ShotType, withText text: String) -> Promise<CommentType> {
        return try! postCommentForShotStub.invoke(shot, text)
    }
}
