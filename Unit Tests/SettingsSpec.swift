//
//  SettingsSpec.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 24.03.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class SettingsSpec: QuickSpec {
    
    var didReceiveStreamSourceNotification = false
    var didReceiveNotificationsNotification = false
    
    override func spec() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "streamNotification:", name: InbbboxNotificationKey.UserDidChangeStreamSourceSettings.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationsNotification:", name: InbbboxNotificationKey.UserDidChangeNotificationsSettings.rawValue, object: nil)
        
        describe("when changing settings") {
            Settings.StreamSource.Debuts = true
            Settings.Reminder.Enabled = false
            
            it("should receive notification") {
                expect(self.didReceiveStreamSourceNotification).to(beTrue())
                expect(self.didReceiveNotificationsNotification).to(beTrue())
            }
        }
    }
    
    @objc func streamNotification(notification: NSNotification) {
        didReceiveStreamSourceNotification = true
    }
    
    @objc func notificationsNotification(notification: NSNotification) {
        didReceiveNotificationsNotification = true
    }
}
