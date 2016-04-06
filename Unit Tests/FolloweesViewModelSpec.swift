//
//  FolloweesViewModelSpec.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 01.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class FolloweesViewModelSpec: QuickSpec {
    
    override func spec() {
        
        var sut: FolloweesViewModelMock!
        let fixtureImageURL = NSURL(string: "https://fixture.domain/fixture.image.normal.png")
        let fixtureImagesURLs: [NSURL]? = [fixtureImageURL!, fixtureImageURL!, fixtureImageURL!, fixtureImageURL!]
        let fixtureFolloweeName = "fixture.name"
        let fixtureNumberOfShots = "1 shot"
        let fixtureAvatarURL = NSURL(string:"fixture.avatar.url")
        
        beforeEach {
            sut = FolloweesViewModelMock()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("When initialized") {
            
            it("should have proper number of shots") {
                expect(sut.itemsCount).to(equal(0))
            }
        }
        
        describe("When downloading initial data") {
            
            beforeEach {
                sut.downloadInitialItems()
            }
            
            it("should have proper number of followees") {
                expect(sut.itemsCount).to(equal(2))
            }
            
            it("should return proper cell data for index path") {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                let cellData = sut.followeeCollectionViewCellViewData(indexPath)
                expect(cellData.name).to(equal(fixtureFolloweeName))
                expect(cellData.numberOfShots).to(equal(fixtureNumberOfShots))
                expect(cellData.shotsImagesURLs).to(equal(fixtureImagesURLs))
                expect(cellData.avatarString).to(equal(fixtureAvatarURL))
            }
        }
        
        describe("When downloading data for next page") {
            
            beforeEach {
                sut.downloadItemsForNextPage()
            }
            
            it("should have proper number of shots") {
                expect(sut.itemsCount).to(equal(3))
            }
            
            it("should return proper shot data for index path") {
                let indexPath = NSIndexPath(forRow: 1, inSection: 0)
                let cellData = sut.followeeCollectionViewCellViewData(indexPath)
                expect(cellData.name).to(equal(fixtureFolloweeName))
                expect(cellData.numberOfShots).to(equal(fixtureNumberOfShots))
                expect(cellData.shotsImagesURLs).to(equal(fixtureImagesURLs))
                expect(cellData.avatarString).to(equal(fixtureAvatarURL))
            }
        }
    }
}

//Explanation: Create mock class to override methods from BaseCollectionViewViewModel.

private class FolloweesViewModelMock: FolloweesViewModel {
    
    override func downloadInitialItems() {
        let followee = User.fixtureUser()
        followees = [followee, followee]
        downloadShots(followees)
    }
    
    override func downloadItemsForNextPage() {
        let followee = User.fixtureUser()
        followees = [followee, followee, followee]
        downloadShots(followees)
    }
    
    override func downloadShots(followees: [Followee]) {
        for index in 0...followees.count - 1 {
            followeesIndexedShots[index] = [Shot.fixtureShot()]
        }
    }
}
