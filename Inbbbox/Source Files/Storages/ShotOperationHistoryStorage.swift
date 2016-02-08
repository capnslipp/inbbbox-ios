//
//  ShotOperationHistoryStorage.swift
//  Inbbbox
//
//  Created by Peter Bruz on 07/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import CoreData

final class ShotOperationHistoryStorage {
    
    private let EntityName = "ShotOperation"
    
    private enum Attribute: String {
        case ShotID = "shot_id"
        case OperationType = "operation_type"
        case BucketID = "bucket_id"
    }
    
    private let entity: NSEntityDescription!
    private let fetchRequest: NSFetchRequest!
    
    private(set) var managedContext: NSManagedObjectContext!
    
    init(managedContext: NSManagedObjectContext? = nil) {
        self.managedContext = managedContext ?? (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        entity = NSEntityDescription.entityForName(EntityName, inManagedObjectContext: self.managedContext)
        fetchRequest = NSFetchRequest(entityName: EntityName)
    }
    
    func insertRecord(shotID: String, operation: ShotOperationType, bucketID: String? = nil) throws {
        
        let changeRecord = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        changeRecord.setValue(shotID, forKey: Attribute.ShotID.rawValue)
        changeRecord.setValue(operation.rawValue, forKey: Attribute.OperationType.rawValue)
        
        do {
            try managedContext.save()
        } catch {
            throw error
        }
    }
    
    func allRecords() throws -> [ShotOperation]? {
        
        do {
            guard let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] else { return nil }
            
            
            //NGRToDo: refactor this:
            var changeHistory = [ShotOperation]()
            
            _ = results.map {
                changeHistory.append(ShotOperation(shotID: $0.valueForKey(Attribute.ShotID.rawValue) as! String, operation: ShotOperationType(rawValue: $0.valueForKey(Attribute.OperationType.rawValue) as! Int)!, bucketID: $0.valueForKey(Attribute.BucketID.rawValue) as? String))
            }
            
            return changeHistory
            
        } catch {
            throw error
        }
    }
    
    func clearHistory() throws {
        
        do {
            if let objects = try! managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                objects.forEach { managedContext.deleteObject($0) }
                
                try managedContext.save()
            }
        } catch {
            throw error
        }
    }
}

struct ShotOperation {
    
    var shotID: String
    var type: ShotOperationType
    var bucketID: String?
    
    init(shotID: String, operation: ShotOperationType, bucketID: String? = nil) {
        self.shotID = shotID
        type = operation
    }
}

enum ShotOperationType: Int {
    case Like = 0
    case Unlike = 1
    case AddToBucket = 2
    case RemoveFromBucket = 3
}
