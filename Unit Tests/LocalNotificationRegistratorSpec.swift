//
//  LocalNotificationRegistratorSpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 04/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class LocalNotificationRegistratorSpec: QuickSpec {
    
    override func spec() {
        
        let fixtureUserID = "fixture.user.id"
        
        describe("when managing local notifications") {
            
            var localNotification: UILocalNotification?
            
            describe("when local notification registered") {
                
                beforeEach {
                    localNotification = LocalNotificationRegistrator.registerNotification(forUserID: fixtureUserID, time: NSDate())
                }
                
                it("notification shouldn't be nil") {
                    expect(localNotification).toNot(beNil())
                }
                
                it("notification should have notificationID same as userID") {
                    let userInfo = localNotification!.userInfo!
                    expect(userInfo["notificationID"] as! String).to(equal(fixtureUserID))
                }
            }
            
            describe("when local notification unregistered") {
                
                var containsNotification = false
                
                beforeEach {
                    LocalNotificationRegistrator.unregisterNotification(forUserID: fixtureUserID)
                }
                
                it("notification should not exist") {
                    
                    if let scheduledLocalNotifications = UIApplication.sharedApplication().scheduledLocalNotifications {
                        containsNotification = scheduledLocalNotifications.contains(localNotification!)
                    }
                    
                    expect(containsNotification).to(beFalse())
                }
            }
        }
    }
}
