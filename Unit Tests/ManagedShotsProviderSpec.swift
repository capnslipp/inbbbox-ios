//
//  ManagedProjectsProviderSpec.swift
//  Inbbbox
//
//  Created by Lukasz Wolanczyk on 2/29/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import CoreData
import PromiseKit

@testable import Inbbbox

class ManagedShotsProviderSpec: QuickSpec {

    override func spec() {

        var sut: ManagedShotsProvider!

        beforeEach {
            sut = ManagedShotsProvider()
        }

        afterEach {
            sut = nil
        }

        it("should have managed object context") {
            expect(sut.managedObjectContext).toNot(beNil())
        }

        describe("provide my liked shots") {

            var inMemoryManagedObjectContext: NSManagedObjectContext!
            var likedShot: ManagedShot!
            var returnedShots: [ManagedShot]!

            beforeEach {
                inMemoryManagedObjectContext = setUpInMemoryManagedObjectContext()
                let managedObjectsProvider = ManagedObjectsProvider(managedObjectContext: inMemoryManagedObjectContext)
                likedShot = managedObjectsProvider.managedShot(Shot.fixtureShot())
                likedShot.liked = true
                sut.managedObjectContext = inMemoryManagedObjectContext
                firstly {
                    sut.provideMyLikedShots()
                }.then { shots in
                    returnedShots = shots!.map { $0 as! ManagedShot }
                }
            }

            it("should return 1 liked shot") {
                expect(returnedShots.count).toEventually(equal(1))
                let returnedLikedShot = returnedShots[0]
                expect(returnedLikedShot.identifier).toEventually(equal(likedShot.identifier))
            }
        }
    }
}
