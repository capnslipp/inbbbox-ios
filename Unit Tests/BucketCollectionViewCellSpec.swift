//
//  BucketCollectionViewCellSpec.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 25.01.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble

@testable import Inbbbox

class BucketCollectionViewCellSpec: QuickSpec {

    override func spec() {
        
        describe("height aware") {
            
            describe("preferred height") {
                
                var preferredHeight: CGFloat?
                
                beforeEach {
                    preferredHeight = BucketCollectionViewCell.preferredHeight
                }
                
                it("should have proper preferred height") {
                    expect(preferredHeight).to(equal(170))
                }
            }
        }
        
        describe("width aware") {
            
            describe("preferred width") {
                
                var preferredWidth: CGFloat?
                
                beforeEach {
                    preferredWidth = BucketCollectionViewCell.preferredWidth
                }
                
                it("should have proper preferred width") {
                    expect(preferredWidth).to(equal(140))
                }
            }
        }
        
        describe("reusable") {
            
            describe("reuse identifier") {
                
                var reuseIdentifier: String?
                
                beforeEach {
                    reuseIdentifier = BucketCollectionViewCell.reuseIdentifier
                }
                
                it("should have proper reuse identifier") {
                    expect(reuseIdentifier).to(equal("BucketCollectionViewCellIdentifier"))
                }
            }
        }
    }
}
