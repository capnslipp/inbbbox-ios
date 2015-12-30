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
        
        describe("when formatting date with basic date formatter") {
            
            var dateComponents: NSDateComponents!
            
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
    }
}
