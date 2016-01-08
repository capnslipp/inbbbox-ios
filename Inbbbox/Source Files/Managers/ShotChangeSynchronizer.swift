//
//  ShotChangeSynchronizer.Swift
//  Inbbbox
//
//  Created by Peter Bruz on 07/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

final class ShotChangeSynchronizer {
    
    class func synchronize() throws {
        
        do {
            if let shotChanges = try ShotChangeHistoryStorage.allRecords() {
                
                for change in shotChanges {
                    switch change.operationType {
                    case .Like:
                        // NGRTodo: like shot query
                        break
                    case .Unlike:
                        // NGRTodo: unlike shot query
                        break
                    case .AddToBucket:
                        // NGRTodo: add to bucket query
                        break
                    case .RemoveFromBucket:
                        // NGRTodo: remove from bucket query
                        break
                    }
                }
                
                try ShotChangeHistoryStorage.clearHistory()
                try ShotsLocalStorage.clear()
            }
        } catch {
            throw error
        }
    }
    
    // NGRTemp: temp name for method that should get buckets' names and ids before logging out in case to add shots to buckets while using as guest
    class func synchronizeBucketsBeforeLogOut() {
        // NGRTodo: get user's buckets
    }
}
