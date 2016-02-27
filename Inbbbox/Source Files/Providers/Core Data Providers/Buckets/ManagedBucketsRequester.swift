//
//  ManagedBucketsRequester.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/23/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit
import CoreData

class ManagedBucketsRequester {
    
    let managedObjectContext: NSManagedObjectContext
    let managedObjectsProvider: ManagedObjectsProvider
    
    init() {
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        managedObjectsProvider = ManagedObjectsProvider(managedObjectContext: managedObjectContext)
    }
    
    
    func addShot(shot: ShotType, toBucket bucket: BucketType) -> Promise<Void> {
        let managedBucket = managedObjectsProvider.managedBucket(bucket)
        let managedShot = managedObjectsProvider.managedShot(shot)
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

        let managedBucket = managedObjectsProvider.managedBucket(bucket)
        let managedShot = managedObjectsProvider.managedShot(shot)
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
