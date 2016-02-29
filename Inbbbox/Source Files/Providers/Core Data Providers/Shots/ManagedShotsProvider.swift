//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import CoreData

class ManagedShotsProvider {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func provideMyLikedShots() -> Promise<[ShotType]?> {
        let fetchRequest = NSFetchRequest(entityName: ManagedShot.entityName)
        fetchRequest.predicate = NSPredicate(format: "liked == true")

        return Promise<[ShotType]?> { fulfill, reject in
            do {
                let managedShots = try managedObjectContext.executeFetchRequest(fetchRequest) as! [ManagedShot]
                fulfill(managedShots.map { $0 as ShotType})
            } catch {
                reject(error)
            }
        }
    }
}
