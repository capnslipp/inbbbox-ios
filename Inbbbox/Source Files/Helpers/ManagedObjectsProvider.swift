//
//  ManagedObjectsProvider.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/18/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import CoreData

struct ManagedObjectsProvider {

    let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func managedShot(shot: ShotType) -> ManagedShot {
        let fetchRequest = NSFetchRequest(entityName: ManagedShot.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", shot.identifier)

        let firstFetchedObject = try? managedObjectContext.executeFetchRequest(fetchRequest).first
        if let managedShot = firstFetchedObject as? ManagedShot {
            return managedShot
        }

        let managedShotEntity = NSEntityDescription.entityForName(ManagedShot.entityName,
                                          inManagedObjectContext: managedObjectContext)!
        let managedShot = ManagedShot(entity: managedShotEntity,
              insertIntoManagedObjectContext: managedObjectContext)
        managedShot.mngd_identifier = shot.identifier
        managedShot.mngd_title = shot.title
        managedShot.mngd_htmlDescription = shot.attributedDescription
        managedShot.mngd_user = managedUser(shot.user)
        managedShot.mngd_shotImage = managedShotImage(shot.shotImage)
        managedShot.mngd_createdAt = shot.createdAt
        managedShot.mngd_animated = shot.animated
        managedShot.mngd_likesCount = shot.likesCount
        managedShot.mngd_viewsCount = shot.viewsCount
        managedShot.mngd_commentsCount = shot.commentsCount
        managedShot.mngd_bucketsCount = shot.bucketsCount
        if let team = shot.team {
            managedShot.mngd_team = managedTeam(team)
        }
        return managedShot
    }

    func managedUser(user: UserType) -> ManagedUser {
        let fetchRequest = NSFetchRequest(entityName: ManagedUser.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", user.identifier)

        let firstFetchedObject = try? managedObjectContext.executeFetchRequest(fetchRequest).first
        if let managedUser = firstFetchedObject as? ManagedUser {
            return managedUser
        }

        let managedUserEntity = NSEntityDescription.entityForName(ManagedUser.entityName,
                                          inManagedObjectContext: managedObjectContext)!
        let managedUser = ManagedUser(entity: managedUserEntity,
              insertIntoManagedObjectContext: managedObjectContext)
        managedUser.mngd_identifier = user.identifier
        managedUser.mngd_name = user.name
        managedUser.mngd_username = user.username
        managedUser.mngd_avatarURL = user.avatarURL?.absoluteString
        managedUser.mngd_shotsCount = user.shotsCount
        managedUser.mngd_accountType = user.accountType?.rawValue
        return managedUser
    }

    func managedTeam(team: TeamType) -> ManagedTeam {
        let fetchRequest = NSFetchRequest(entityName: ManagedTeam.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", team.identifier)

        let firstFetchedObject = try? managedObjectContext.executeFetchRequest(fetchRequest).first
        if let managedTeam = firstFetchedObject as? ManagedTeam {
            return managedTeam
        }

        let managedTeamEntity = NSEntityDescription.entityForName(ManagedTeam.entityName,
                                          inManagedObjectContext: managedObjectContext)!
        let managedTeam = ManagedTeam(entity: managedTeamEntity,
              insertIntoManagedObjectContext: managedObjectContext)
        managedTeam.mngd_identifier = team.identifier
        managedTeam.mngd_name = team.name
        managedTeam.mngd_username = team.username
        managedTeam.mngd_avatarURL = team.avatarURL?.absoluteString
        managedTeam.mngd_createdAt = team.createdAt
        return managedTeam
    }

    func managedShotImage(shotImage: ShotImageType) -> ManagedShotImage {
        let fetchRequest = NSFetchRequest(entityName: ManagedShotImage.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_normalURL == %@",
                shotImage.normalURL.absoluteString)

        let firstFetchedObject = try? managedObjectContext.executeFetchRequest(fetchRequest).first
        if let managedShotImage = firstFetchedObject as? ManagedShotImage {
            return managedShotImage
        }
        let managedShotImageEntity = NSEntityDescription.entityForName(ManagedShotImage.entityName,
                                               inManagedObjectContext: managedObjectContext)!
        let managedShotImage = ManagedShotImage(entity: managedShotImageEntity,
                        insertIntoManagedObjectContext: managedObjectContext)
        managedShotImage.mngd_hidpiURL = shotImage.hidpiURL?.absoluteString
        managedShotImage.mngd_normalURL = shotImage.normalURL.absoluteString
        managedShotImage.mngd_teaserURL = shotImage.teaserURL.absoluteString
        return managedShotImage
    }

    func managedBucket(bucket: BucketType) -> ManagedBucket {
        let fetchRequest = NSFetchRequest(entityName: ManagedBucket.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", bucket.identifier)

        let firstFetchedObject = try? managedObjectContext.executeFetchRequest(fetchRequest).first
        if let managedBucket = firstFetchedObject as? ManagedBucket {
            return managedBucket
        }
        let managedBucketEntity = NSEntityDescription.entityForName(ManagedBucket.entityName,
                                            inManagedObjectContext: managedObjectContext)!
        let managedBucket = ManagedBucket(entity: managedBucketEntity,
                  insertIntoManagedObjectContext: managedObjectContext)
        managedBucket.mngd_identifier = bucket.identifier
        managedBucket.mngd_name = bucket.name
        managedBucket.mngd_htmlDescription = bucket.attributedDescription
        managedBucket.mngd_shotsCount = bucket.shotsCount
        managedBucket.mngd_createdAt = bucket.createdAt
        return managedBucket
    }

    func managedProject(project: ProjectType) -> ManagedProject {
        let fetchRequest = NSFetchRequest(entityName: ManagedProject.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", project.identifier)

        let firstFetchedObject = try? managedObjectContext.executeFetchRequest(fetchRequest).first
        if let managedProject = firstFetchedObject as? ManagedProject {
            return managedProject
        }
        let managedProjectEntity = NSEntityDescription.entityForName(ManagedProject.entityName,
                                             inManagedObjectContext: managedObjectContext)!
        let managedProject = ManagedProject(entity: managedProjectEntity,
                    insertIntoManagedObjectContext: managedObjectContext)
        managedProject.mngd_identifier = project.identifier
        managedProject.mngd_name = project.name
        managedProject.mngd_htmlDescription = project.attributedDescription
        managedProject.mngd_createdAt = project.createdAt
        managedProject.mngd_shotsCount = project.shotsCount
        return managedProject
    }
}
