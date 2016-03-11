//
//  TeamSpecExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 10/03/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import SwiftyJSON

@testable import Inbbbox

extension Team {
    
    static func fixtureTeam() -> Team {
        let json = JSONSpecLoader.sharedInstance.jsonWithResourceName("Team")
        return Team.map(json)
    }
}
