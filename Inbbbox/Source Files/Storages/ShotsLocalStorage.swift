//
//  ShotsLocalStorage.swift
//  Inbbbox
//
//  Created by Peter Bruz on 08/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import CoreData

final class ShotsLocalStorage {
    
    private static let ShotEntityName = "Shot"
    private static let BucketEntityName = "Bucket"
    
    private static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private static let managedContext = appDelegate.managedObjectContext
    private static let shotEntity = NSEntityDescription.entityForName(ShotEntityName, inManagedObjectContext: managedContext)
    private static let bucketEntity = NSEntityDescription.entityForName(BucketEntityName, inManagedObjectContext: managedContext)
    
    class var likedShots: [ShotManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName: ShotEntityName)
        let predicate = NSPredicate(format: "liked == true")
        fetchRequest.predicate = predicate
        
        return try! managedContext.executeFetchRequest(fetchRequest) as! [ShotManagedObject]
    }
    
    class func like(shotID shotID: Int) throws {
        
        let shotFetchRequest = NSFetchRequest(entityName: ShotEntityName)
        let shotPredicate = NSPredicate(format: "id == %d", shotID)
        shotFetchRequest.predicate = shotPredicate
        
        do {
            if let shots = try managedContext.executeFetchRequest(shotFetchRequest) as? [ShotManagedObject] where shots.count > 0 {
                let shotToLike = shots[0]
                shotToLike.liked = true
            } else {
                let shot = NSManagedObject(entity: shotEntity!, insertIntoManagedObjectContext: managedContext) as! ShotManagedObject
                shot.id = shotID
                shot.liked = true
            }
            
            try managedContext.save()
            
        } catch {
            throw error
        }
    }
    
    class func unlike(shotID shotID: Int) throws {
        
        let shotFetchRequest = NSFetchRequest(entityName: ShotEntityName)
        let shotPredicate = NSPredicate(format: "id == %d", shotID)
        shotFetchRequest.predicate = shotPredicate
        
        do {
            if let shots = try managedContext.executeFetchRequest(shotFetchRequest) as? [ShotManagedObject] where shots.count > 0 {
                let shotToUnlike = shots[0]
                if let buckets = shotToUnlike.buckets where buckets.count > 0 {
                    shotToUnlike.liked = false
                } else {
                    managedContext.deleteObject(shotToUnlike)
                }
                
                try managedContext.save()
                
            }
        } catch {
            throw error
        }
    }
    
    class func addToBucket(shotID shotID: Int, bucketID: Int) throws {
        
        let bucketFetchRequest = NSFetchRequest(entityName: BucketEntityName)
        let bucketPredicate = NSPredicate(format: "id == %d", bucketID)
        bucketFetchRequest.predicate = bucketPredicate
        
        let shotFetchRequest = NSFetchRequest(entityName: ShotEntityName)
        let shotPredicate = NSPredicate(format: "id == %d", shotID)
        shotFetchRequest.predicate = shotPredicate
        
        do {
            var bucket: BucketManagedObject?
            var shot: ShotManagedObject
            
            if let buckets = try managedContext.executeFetchRequest(bucketFetchRequest) as? [BucketManagedObject] where buckets.count > 0 {
                bucket = buckets[0]
            }
            
            if let shots = try managedContext.executeFetchRequest(shotFetchRequest) as? [ShotManagedObject] where shots.count > 0 {
                shot = shots[0]
                shot.addBucket(bucket!)
            } else {
                let shot = NSManagedObject(entity: shotEntity!, insertIntoManagedObjectContext: managedContext) as! ShotManagedObject
                shot.id = shotID
                shot.liked = false
                shot.buckets = NSSet(array: [bucket!])
            }
            
            try managedContext.save()
            
        } catch {
            throw error
        }
    }
    
    class func removeFromBucket(shotID shotID: Int, bucketID: Int) throws {
        
        let bucketFetchRequest = NSFetchRequest(entityName: BucketEntityName)
        let bucketPredicate = NSPredicate(format: "id == %d", bucketID)
        bucketFetchRequest.predicate = bucketPredicate
        
        let shotFetchRequest = NSFetchRequest(entityName: ShotEntityName)
        let shotPredicate = NSPredicate(format: "id == %d", shotID)
        shotFetchRequest.predicate = shotPredicate
        
        do {
            var shot: ShotManagedObject?
            var bucket: BucketManagedObject
            
            if let shots = try managedContext.executeFetchRequest(shotFetchRequest) as? [ShotManagedObject] where shots.count > 0 {
                shot = shots[0]
            }
            
            if let buckets = try managedContext.executeFetchRequest(bucketFetchRequest) as? [BucketManagedObject] where buckets.count > 0 {
                bucket = buckets[0]
                let bucketShots = bucket.shots as? NSMutableSet
                bucketShots?.removeObject(shot!)
            }
        } catch {
            throw error
        }
    }
    
    class func clear() throws {
        
        let fetchRequest = NSFetchRequest(entityName: ShotEntityName)
        
        do {
            if let objects = try managedContext.executeFetchRequest(fetchRequest) as? [ShotManagedObject] {
                _ = objects.map {
                    managedContext.deleteObject($0)
                }
            }
            
            try managedContext.save()
            
        } catch {
            throw error
        }
    }
}
