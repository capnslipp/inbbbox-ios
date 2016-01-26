//
//  FormatterSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 30/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class FormatterSpec: QuickSpec {
    override func spec() {
        
        var dateComponents: NSDateComponents!
        
        afterEach {
            dateComponents = nil
        }
        
        describe("when formatting date with basic date formatter") {
            
            beforeEach {
                let date = Formatter.Date.Basic.dateFromString("1970-01-01")!
                dateComponents = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
            }
            
            it("year should be properly decoded") {
                expect(dateComponents.year).to(equal(1970))
            }
            
            it("month should be properly decoded") {
                expect(dateComponents.month).to(equal(1))
            }
            
            it("day should be properly decoded") {
                expect(dateComponents.day).to(equal(1))
            }
        }
        
        describe("when formatting date with timestamp date formatter") {
            
            beforeEach {
                let date = Formatter.Date.Timestamp.dateFromString("1970-01-01T08:19:14+00:00")!
                let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                calendar.timeZone = NSTimeZone(abbreviation: "GMT")!
                dateComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
            }
            
            it("year should be properly decoded") {
                expect(dateComponents.year).to(equal(1970))
            }
            
            it("month should be properly decoded") {
                expect(dateComponents.month).to(equal(1))
            }
            
            it("day should be properly decoded") {
                expect(dateComponents.day).to(equal(1))
            }
            
            it("hour should be properly decoded") {
                expect(dateComponents.hour).to(equal(8))
            }
            
            it("minute should be properly decoded") {
                expect(dateComponents.minute).to(equal(19))
            }
            
            it("second should be properly decoded") {
                expect(dateComponents.second).to(equal(14))
            }
        }
    }
}
