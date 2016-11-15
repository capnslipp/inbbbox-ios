//
//  APIAttachementsProvider.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 15.11.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

class APIAttachementsProvider: PageableProvider {
    
    /**
     Provides attachements for given shot.
     
     - parameter shot: Shot which attachements we want to download
     
     - returns: Promise which resolves with attachements or nil.
     */
    func provideAttachementsForShot(shot: ShotType) -> Promise<[Attachement]?> {
        let query = AttachementQuery(shot: shot)
        return Promise<[Attachement]?> { fulfill, reject in
            firstly {
                firstPageForQueries([query], withSerializationKey: nil)
            }.then { (attachements: [Attachement]?) -> Void in
                fulfill(attachements.flatMap { $0.map { $0 as Attachement } })
            }.error(reject)
        }
    }
}
