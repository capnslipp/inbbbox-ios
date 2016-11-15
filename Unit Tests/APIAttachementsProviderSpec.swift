//
//  APIAttachementsProviderSpec.swift
//  Inbbbox
//
//  Created by Marcin Siemaszko on 15.11.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import PromiseKit

@testable import Inbbbox

class APIAttachementsProviderSpec: QuickSpec {
    override func spec() {
        
        var sut: APIAttachementsProviderPrivateMock!
        
        beforeEach {
            sut = APIAttachementsProviderPrivateMock()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("when providing attachements") {
            
            context("and they exist") {
                
                var attachements: [Attachement]?
                
                afterEach {
                    attachements = nil
                }
                
                it("attachements should be properly returned") {
                    sut.provideAttachementsForShot(Shot.fixtureShot()).then { _attachements -> Void in
                        attachements = _attachements
                        }.error { _ in fail() }
                    
                    expect(attachements).toNotEventually(beNil())
                    expect(attachements).toEventually(haveCount(3))
                    expect(attachements?.first?.identifier).toEventually(equal("1"))
                }
            }
        }
    }
}

//Explanation: Create APIAttachementsProviderPrivateMock to override methods from PageableProvider.
private class APIAttachementsProviderPrivateMock: APIAttachementsProvider {
    
    override func firstPageForQueries<T: Mappable>(queries: [Query], withSerializationKey key: String?) -> Promise<[T]?> {
        return mockResult(T)
    }
    
    override func nextPageFor<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return mockResult(T)
    }
    
    override func previousPageFor<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return mockResult(T)
    }
    
    func mockResult<T: Mappable>(type: T.Type) -> Promise<[T]?> {
        return Promise<[T]?> { fulfill, _ in
            
            let json = JSONSpecLoader.sharedInstance.fixtureAttachementsJSON(withCount: 3)
            let result = json.map { T.map($0) }
            
            fulfill(result)
        }
    }
}
