//
//  LocalNotificationRegistratorSpec.swift
//  Inbbbox
//
//  Created by Peter Bruz on 04/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import SwiftyUserDefaults

@testable import Inbbbox

class LocalNotificationRegistratorSpec: QuickSpec {
    
    override func spec() {
        
        let fixtureUserID = "fixture.user.id"
        
        describe("when managing local notifications") {
            
            var localNotificationSettingsTypeFits: Bool {
                if let localNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings() {
                    return localNotificationSettings.types == [.Alert, .Sound]
                }
                return false
            }
            
            var localNotification: UILocalNotification?
            
            describe("when local notification registered") {
                
                beforeEach {
                    localNotification = LocalNotificationRegistrator.registerNotification(forUserID: fixtureUserID, time: NSDate())
                }
                
                afterEach {
                    localNotification = nil
                }
                
                if localNotificationSettingsTypeFits {
                    
                    it("notification shouldn't be nil") {
                        expect(localNotification).toNot(beNil())
                    }
                    
                    it("notification should have notificationID same as userID") {
                        let userInfo = localNotification!.userInfo!
                        expect(userInfo["notificationID"] as? String).to(equal(fixtureUserID))
                    }
                    
                } else {
                    
                    it("notification should be nil") {
                        expect(localNotification).to(beNil())
                    }
                }
            }
            
            describe("when local notification unregistered") {
                
                var containsNotification = false
                
                beforeEach {
                    localNotification = LocalNotificationRegistrator.registerNotification(forUserID: fixtureUserID, time: NSDate())
                    LocalNotificationRegistrator.unregisterNotification(forUserID: fixtureUserID)
                }
                
                afterEach {
                    localNotification = nil
                }
                
                it("notification should not exist") {
                    
                    if let localNotification = localNotification, scheduledLocalNotifications = UIApplication.sharedApplication().scheduledLocalNotifications {
                        containsNotification = scheduledLocalNotifications.contains(localNotification)
                    }
                    
                    expect(containsNotification).to(beFalse())
                }
            }
        }
    }
}
