//
//  CommentSpecExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 10/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import SwiftyJSON

@testable import Inbbbox

extension Comment {
    
    static func fixtureComment() -> Comment {
        let json = JSONSpecLoader.sharedInstance.jsonWithResourceName("Comment")
        return Comment.map(json)
    }
}
