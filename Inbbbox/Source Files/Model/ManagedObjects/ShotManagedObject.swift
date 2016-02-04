//
//  ShotManagedObject.swift
//  Inbbbox
//
//  Created by Peter Bruz on 08/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import CoreData

class ShotManagedObject: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var liked: Bool
    @NSManaged var buckets: NSSet?
    
    func addBucket(bucket: BucketManagedObject) {
        addObject(bucket, forKey: "buckets")
    }
}
