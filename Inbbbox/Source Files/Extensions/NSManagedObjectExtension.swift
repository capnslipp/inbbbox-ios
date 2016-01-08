//
//  NSManagedObjectExtension.swift
//  Inbbbox
//
//  Created by Peter Bruz on 08/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    func addObject(value: NSManagedObject, forKey: String) {
        self.mutableSetValueForKey(forKey).addObject(value)
    }
    
    func removeObject(value: NSManagedObject, forKey: String) {
        self.mutableSetValueForKey(forKey).removeObject(value)
    }
}
