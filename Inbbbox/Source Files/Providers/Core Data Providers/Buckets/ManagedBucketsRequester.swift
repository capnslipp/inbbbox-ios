//
//  ManagedBucketsRequester.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/23/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class ManagedBucketsRequester {
    
    func addShot(shot: ShotType, toBucket bucket: BucketType) -> Promise<Void> {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let managedBucket = ManagedObjectsProvider.managedBucket(bucket, inManagedObjectContext: managedObjectContext)
        let managedShot = ManagedObjectsProvider.managedShot(shot, inManagedObjectContext: managedObjectContext)
        if let managedShots = managedBucket.shots {
            managedShots.setByAddingObject(managedShot)
        } else {
            managedBucket.shots = NSSet(object: managedShot)
        }
        return Promise<Void> { fulfill, reject in
            do {
                fulfill(try managedObjectContext.save())
            } catch {
                reject(error)
            }
        }
    }

    func removeShot(shot: ShotType, fromBucket bucket: BucketType) -> Promise<Void> {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let managedBucket = ManagedObjectsProvider.managedBucket(bucket, inManagedObjectContext: managedObjectContext)
        let managedShot = ManagedObjectsProvider.managedShot(shot, inManagedObjectContext: managedObjectContext)
        if let managedShots = managedBucket.shots{
            let mutableShots = NSMutableSet(set: managedShots)
            mutableShots.removeObject(managedShot)
            managedBucket.shots = mutableShots.copy() as? NSSet
        }
        return Promise<Void> { fulfill, reject in
            do {
                fulfill(try managedObjectContext.save())
            } catch {
                reject(error)
            }
        }
    }
}
