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
    
    static func managedShot(shot: ShotType, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> ManagedShot {
        let fetchRequest = NSFetchRequest(entityName: ManagedShot.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", shot.identifier)

        if let managedShot = try! managedObjectContext.executeFetchRequest(fetchRequest).first as? ManagedShot {
            return managedShot
        }
        
        let managedShotEntity = NSEntityDescription.entityForName(ManagedShot.entityName, inManagedObjectContext: managedObjectContext)!
        let managedShot = ManagedShot(entity: managedShotEntity, insertIntoManagedObjectContext: managedObjectContext)
        managedShot.mngd_identifier = shot.identifier
        managedShot.mngd_title = shot.title
        managedShot.mngd_htmlDescription = shot.htmlDescription
        managedShot.mngd_user = managedUser(shot.user, inManagedObjectContext: managedObjectContext)
        managedShot.mngd_shotImage = managedShotImage(shot.shotImage, inManagedObjectContext: managedObjectContext)
        managedShot.mngd_createdAt = shot.createdAt
        managedShot.mngd_animated = shot.animated
        managedShot.mngd_likesCount = NSNumber(unsignedInteger: shot.likesCount)
        managedShot.mngd_viewsCount = NSNumber(unsignedInteger: shot.viewsCount)
        managedShot.mngd_commentsCount = NSNumber(unsignedInteger: shot.commentsCount)
        managedShot.mngd_bucketsCount = NSNumber(unsignedInteger: shot.bucketsCount)
        if let team = shot.team {
            managedShot.mngd_team = managedTeam(team, inManagedObjectContext: managedObjectContext)
        }
        return managedShot
    }
    
    static func managedUser(user: UserType, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> ManagedUser {
        let fetchRequest = NSFetchRequest(entityName: ManagedUser.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", user.identifier)

        if let managedUser = try! managedObjectContext.executeFetchRequest(fetchRequest).first as? ManagedUser {
            return managedUser
        }
        
        let managedUserEntity = NSEntityDescription.entityForName(ManagedUser.entityName, inManagedObjectContext: managedObjectContext)!
        let managedUser = ManagedUser(entity: managedUserEntity, insertIntoManagedObjectContext: managedObjectContext)
        managedUser.mngd_identifier = user.identifier
        managedUser.mngd_name = user.name
        managedUser.mngd_username = user.username
        managedUser.mngd_avatarString = user.avatarString
        managedUser.mngd_shotsCount = NSNumber(integer: user.shotsCount)
        managedUser.mngd_accountType = user.accountType?.rawValue
        return managedUser
    }
    
    static func managedTeam(team: TeamType, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> ManagedTeam {
        let fetchRequest = NSFetchRequest(entityName: ManagedTeam.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", team.identifier)
        
        if let managedTeam = try! managedObjectContext.executeFetchRequest(fetchRequest).first as? ManagedTeam {
            return managedTeam
        }
        
        let managedTeamEntity = NSEntityDescription.entityForName(ManagedTeam.entityName, inManagedObjectContext: managedObjectContext)!
        let managedTeam = ManagedTeam(entity: managedTeamEntity, insertIntoManagedObjectContext: managedObjectContext)
        managedTeam.mngd_identifier = team.identifier
        managedTeam.mngd_name = team.name
        managedTeam.mngd_username = team.username
        managedTeam.mngd_avatarString = team.avatarString
        managedTeam.mngd_createdAt = team.createdAt
        return managedTeam
    }
    
    static func managedShotImage(shotImage: ShotImageType, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> ManagedShotImage {
        let fetchRequest = NSFetchRequest(entityName: ManagedShotImage.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_normalURL == %@", shotImage.normalURL.absoluteString)
        do {
            if let managedShotImage = try managedObjectContext.executeFetchRequest(fetchRequest).first as? ManagedShotImage {
                return managedShotImage
            }
        } catch {
            print(error)
        }
        let managedShotImageEntity = NSEntityDescription.entityForName(ManagedShotImage.entityName, inManagedObjectContext: managedObjectContext)!
        let managedShotImage = ManagedShotImage(entity: managedShotImageEntity, insertIntoManagedObjectContext: managedObjectContext)
        managedShotImage.mngd_hidpiURL = shotImage.hidpiURL?.absoluteString
        managedShotImage.mngd_normalURL = shotImage.normalURL.absoluteString
        managedShotImage.mngd_teaserURL = shotImage.teaserURL.absoluteString
        return managedShotImage
    }
    
    static func managedBucket(bucket: BucketType, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> ManagedBucket {
        let fetchRequest = NSFetchRequest(entityName: ManagedBucket.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", bucket.identifier)
        
        if let managedBucket = try! managedObjectContext.executeFetchRequest(fetchRequest).first as? ManagedBucket {
            return managedBucket
        }
        let managedBucketEntity = NSEntityDescription.entityForName(ManagedBucket.entityName, inManagedObjectContext: managedObjectContext)!
        let managedBucket = ManagedBucket(entity: managedBucketEntity, insertIntoManagedObjectContext: managedObjectContext)
        managedBucket.mngd_identifier = bucket.identifier
        managedBucket.mngd_name = bucket.name
        managedBucket.mngd_htmlDescription = bucket.htmlDescription
        managedBucket.mngd_shotsCount = bucket.shotsCount
        managedBucket.mngd_createdAt = bucket.createdAt
        return managedBucket
    }
    
    static func managedProject(project: ProjectType, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> ManagedProject {
        let fetchRequest = NSFetchRequest(entityName: ManagedProject.entityName)
        fetchRequest.predicate = NSPredicate(format: "mngd_identifier == %@", project.identifier)
        
        if let managedProject = try! managedObjectContext.executeFetchRequest(fetchRequest).first as? ManagedProject {
            return managedProject
        }
        let managedProjectEntity = NSEntityDescription.entityForName(ManagedProject.entityName, inManagedObjectContext: managedObjectContext)!
        let managedProject = ManagedProject(entity: managedProjectEntity, insertIntoManagedObjectContext: managedObjectContext)
        managedProject.mngd_identifier = project.identifier
        managedProject.mngd_name = project.name
        managedProject.mngd_htmlDescription = project.htmlDescription
        managedProject.mngd_createdAt = project.createdAt
        managedProject.mngd_shotsCount = NSNumber(unsignedInteger: project.shotsCount)
        return managedProject
    }
}
