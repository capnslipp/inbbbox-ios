//
//  ProjectsProvider.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 15/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

/// Provides interface for dribbble projects API
class ProjectsProvider: PageableProvider {

    /**
     Provides projects for given shot.
     
     - parameter shot: Shot which projects should be provided.
     
     - returns: Promise which resolves with projects or nil.
     Theoretically should return 1 project only.
     */
    func provideProjectsForShot(shot: Shot) -> Promise<[Project]?> {
        
        let query = ProjectsQuery(shot: shot)
        return firstPageForQueries([query], withSerializationKey: nil)
    }
}
