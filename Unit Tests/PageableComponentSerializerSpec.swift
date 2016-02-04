//
//  PageableComponentSerializerSpec.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 04/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Quick
import Nimble
import Mockingjay

@testable import Inbbbox

class PageableComponentSerializerSpec: QuickSpec {
    override func spec() {
        
        var sut: PageableComponent!
        
        afterEach {
            sut = nil
        }
        
        describe("when serializing next component") {
            
            context("with proper header") {
                
                beforeEach {
                    let header = self.linkHeaderForTypes([.RelNext])
                    sut = PageableComponentSerializer.nextPageableComponentWithSentQuery(MockQuery(), receivedHeader: header)
                }
                
                it("serialized component should not be nil") {
                    expect(sut).toNot(beNil())
                }
                
                it("serialized component should have correct path") {
                    expect(sut.path).to(equal("/fixture.path.next"))
                }
                
                it("serialized component should have query items") {
                    expect(sut.queryItems).toNot(beNil())
                }
                
                it("serialized component should have 2 query items") {
                    expect(sut.queryItems).to(haveCount(2))
                }
                
                it("first query item of serialized component should have proper value") {
                    expect(sut.queryItems!.first!.value).to(equal("3"))
                }
                
                it("first query item of serialized component should have proper name") {
                    expect(sut.queryItems!.first!.name).to(equal("page"))
                }
                
                it("second query item of serialized component should have proper value") {
                    expect(sut.queryItems![1].value).to(equal("100"))
                }
                
                it("second query item of serialized component should have proper name") {
                    expect(sut.queryItems![1].name).to(equal("per_page"))
                }
            }
            
            context("with invalid header") {
                
                beforeEach {
                    let header = ["fixture.header.key": "fixture.header.value"]
                    sut = PageableComponentSerializer.nextPageableComponentWithSentQuery(MockQuery(), receivedHeader: header)
                }
                
                it("serialized component should not be nil") {
                    expect(sut).to(beNil())
                }
            }
        }
        
        describe("when serializing previous component") {
            
            context("with proper header") {
                
                beforeEach {
                    let header = self.linkHeaderForTypes([.RelPrev])
                    sut = PageableComponentSerializer.previousPageableComponentWithSentQuery(MockQuery(), receivedHeader: header)
                }
                
                it("serialized component should not be nil") {
                    expect(sut).toNot(beNil())
                }
                
                it("serialized component should have correct path") {
                    expect(sut.path).to(equal("/fixture.path.prev"))
                }
                
                it("serialized component should have query items") {
                    expect(sut.queryItems).toNot(beNil())
                }
                
                it("serialized component should have 2 query items") {
                    expect(sut.queryItems).to(haveCount(2))
                }
                
                it("first query item of serialized component should have proper value") {
                    expect(sut.queryItems!.first!.value).to(equal("1"))
                }
                
                it("first query item of serialized component should have proper name") {
                    expect(sut.queryItems!.first!.name).to(equal("page"))
                }
                
                it("second query item of serialized component should have proper value") {
                    expect(sut.queryItems![1].value).to(equal("200"))
                }
                
                it("second query item of serialized component should have proper name") {
                    expect(sut.queryItems![1].name).to(equal("per_page"))
                }
                
            }
            
            context("with invalid header") {
                
                beforeEach {
                    let header = ["fixture.header.key": "fixture.header.value"]
                    sut = PageableComponentSerializer.previousPageableComponentWithSentQuery(MockQuery(), receivedHeader: header)
                }
                
                it("serialized component should not be nil") {
                    expect(sut).to(beNil())
                }
            }
        }
    }
}

private struct MockQuery: Query {
    let path = "/fixture/path"
    var parameters = Parameters(encoding: .JSON)
    let method = Method.POST
    
    var service: SecureNetworkService {
        return MockService()
    }
}

private struct MockService: SecureNetworkService {
    
    let scheme = "https"
    let host = "fixture.host"
    let version = "/v1"
    
    func authorizeRequest(request: NSMutableURLRequest) {
        request.setValue("fixture.header", forHTTPHeaderField: "fixture.http.header.field")
    }
}


private enum LinkHeaderType {
    case RelNext, RelPrev
    
    var description: String {
        switch self {
            case .RelNext:
                return "<https://fixture.host/v1/fixture.path.next?page=3&per_page=100>; rel=\"next\""
            case .RelPrev:
                return "<https://fixture.host/v1/fixture.path.prev?page=1&per_page=200>; rel=\"prev\""
        }
    }
}

private extension PageableComponentSerializerSpec {
    
    func linkHeaderForTypes(types: [LinkHeaderType]) -> [String: AnyObject] {
        
        var linkValue = [String]()
        
        types.forEach {
            linkValue.append($0.description)
        }
        
        return [
            "Link" : linkValue.joinWithSeparator(",")
        ]
    }
}
