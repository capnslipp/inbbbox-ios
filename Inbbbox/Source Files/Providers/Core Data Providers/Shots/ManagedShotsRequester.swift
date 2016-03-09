//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import CoreData

class ManagedShotsRequester {
    
    let managedObjectContext: NSManagedObjectContext
    let managedObjectsProvider: ManagedObjectsProvider
    
    init() {
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        managedObjectsProvider = ManagedObjectsProvider(managedObjectContext: managedObjectContext)
    }
    

    func likeShot(shot: ShotType) -> Promise<Void> {
        let managedShot = managedObjectsProvider.managedShot(shot)
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
        let managedShot = managedObjectsProvider.managedShot(shot)
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
        let managedShot = managedObjectsProvider.managedShot(shot)
        return Promise<Bool> { fulfill, _ in
            fulfill(managedShot.liked)
        }
    }
    
    func userBucketsForShot(shot: ShotType) -> Promise<[BucketType]!> {
        let managedShot = managedObjectsProvider.managedShot(shot)
        return Promise<[BucketType]!> { fulfill, _ in
            let managedBuckets = managedShot.buckets?.allObjects as! [ManagedBucket]
            fulfill(managedBuckets.map { $0 as BucketType })
        }
    }
}
