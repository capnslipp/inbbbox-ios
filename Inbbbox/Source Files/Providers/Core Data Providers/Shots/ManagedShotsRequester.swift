//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class ManagedShotsRequester {

    func likeShot(shot: ShotType) -> Promise<Void> {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let managedShot = ManagedObjectsProvider.managedShot(shot, inManagedObjectContext: managedObjectContext)
        managedShot.liked = true
        return Promise<Void> { fulfill, reject in
            do {
                fulfill(try managedObjectContext.save())
            } catch {
                reject(error)
            }
        }
    }

    func unlikeShot(shot: ShotType) -> Promise<Void> {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let managedShot = ManagedObjectsProvider.managedShot(shot, inManagedObjectContext: managedObjectContext)
        managedShot.liked = false
        return Promise<Void> { fulfill, reject in
            do {
                fulfill(try managedObjectContext.save())
            } catch {
                reject(error)
            }
        }
    }

    func isShotLikedByMe(shot: ShotType) -> Promise<Bool> {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let managedShot = ManagedObjectsProvider.managedShot(shot, inManagedObjectContext: managedObjectContext)
        return Promise<Bool> { fulfill, _ in
            fulfill(managedShot.liked)
        }
    }
}
