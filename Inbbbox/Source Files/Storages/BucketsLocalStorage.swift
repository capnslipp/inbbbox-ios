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
    
    private let BucketEntityName = "Bucket"
    
    private let bucketEntity: NSEntityDescription!
    private let bucketFetchRequest: NSFetchRequest!
    
    var managedContext: NSManagedObjectContext!
    
    var buckets: [BucketManagedObject] {
        return try! managedContext.executeFetchRequest(bucketFetchRequest) as! [BucketManagedObject]
    }
    
    private var bucketIDs: [String] {
        
        if let results = try! managedContext.executeFetchRequest(bucketFetchRequest) as? [BucketManagedObject] {
            return results.map { $0.id }
        } else {
            return []
        }
    }
    
    init(managedContext: NSManagedObjectContext? = nil) {
        self.managedContext = managedContext ?? (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        bucketEntity = NSEntityDescription.entityForName(BucketEntityName, inManagedObjectContext: self.managedContext)
        bucketFetchRequest = NSFetchRequest(entityName: BucketEntityName)
    }
    
    func create(bucketID bucketID: String, name: String) throws {
        
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
    
    func destroy(bucketID bucketID: String) throws {
        
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
    
    func findObject(bucketID: String) -> BucketManagedObject? {
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
