//
//  BucketManagedObject.swift
//  Inbbbox
//
//  Created by Peter Bruz on 08/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import CoreData

class BucketManagedObject: NSManagedObject {
    
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var shots: NSSet?
    
    func removeShot(shot: ShotManagedObject) {
        removeObject(shot, forKey: "shots")
    }
}
