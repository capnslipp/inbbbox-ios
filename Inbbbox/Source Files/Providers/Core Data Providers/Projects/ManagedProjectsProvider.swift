//
//  ManagedProjectsProvider.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/22/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PromiseKit

class ManagedProjectsProvider {

    func provideProjectsForShot(shot: ShotType) -> Promise<[ProjectType]?> {
        return Promise<[ProjectType]?> { fulfill, reject in
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let managedShot = ManagedObjectsProvider.managedShot(shot, inManagedObjectContext: managedObjectContext)
            let managedProjects = managedShot.projects?.allObjects as? [ManagedProject]
            fulfill(managedProjects)
        }
    }
}
