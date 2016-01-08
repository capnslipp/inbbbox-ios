//
//  BucketsLocalStorage.swift
//  Inbbbox
//
//  Created by Peter Bruz on 08/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import CoreData

final class BucketsLocalStorage {
    
    private static let BucketEntityName = "Bucket"
    
    private static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private static let managedContext = appDelegate.managedObjectContext
    private static let bucketEntity = NSEntityDescription.entityForName(BucketEntityName, inManagedObjectContext: managedContext)
    private static let bucketFetchRequest = NSFetchRequest(entityName: BucketEntityName)
    
    class var buckets: [BucketManagedObject] {
        return try! managedContext.executeFetchRequest(bucketFetchRequest) as! [BucketManagedObject]
    }
    
    private class var bucketIDs: [Int] {
        
        if let results = try! managedContext.executeFetchRequest(bucketFetchRequest) as? [BucketManagedObject] {
            return results.map { return $0.id }
        } else {
            return []
        }
    }
    
    class func create(bucketID bucketID: Int, name: String) throws {
        
        guard !bucketIDs.contains(bucketID) else { return }
        
        do {
            let bucket = NSManagedObject(entity: bucketEntity!, insertIntoManagedObjectContext: managedContext) as! BucketManagedObject
            bucket.id = bucketID
            bucket.name = name
            
            try managedContext.save()
            
        } catch {
            throw error
        }
    }
    
    class func destroy(bucketID bucketID: Int) throws {
        
        do {
            if let objectToDelete = findObject(bucketID) {
                managedContext.deleteObject(objectToDelete)
            }
            
            try managedContext.save()
            
        } catch {
            throw error
        }
    }
}

private extension BucketsLocalStorage {
    
    class func findObject(bucketID: Int) -> BucketManagedObject? {
        if let objects = try! managedContext.executeFetchRequest(bucketFetchRequest) as? [BucketManagedObject] {
            let fittingObjects = objects.filter {
                return $0.id == bucketID
            }
            return fittingObjects.first
        } else {
            return nil
        }
    }
}
