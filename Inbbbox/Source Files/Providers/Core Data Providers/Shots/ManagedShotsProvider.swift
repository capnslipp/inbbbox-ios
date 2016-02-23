//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import CoreData

class ManagedShotsProvider {
    func provideLikedShotsForUser(user: UserType) -> Promise<[ShotType]?> {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: ManagedShot.entityName)
        let likedPredicate = NSPredicate(format: "liked == true")
        let userPredicate = NSPredicate(format: "mngd_user.mngd_identifier == %@", user.identifier)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [likedPredicate, userPredicate])

        return Promise<[ShotType]?> { fulfill, reject in
            do {
                fulfill(try managedObjectContext.executeFetchRequest(fetchRequest) as! [ManagedShot])
            } catch {
                reject(error)
            }
        }
    }
}
