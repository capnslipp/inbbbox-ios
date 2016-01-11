//
//  ShotChangeSynchronizer.Swift
//  Inbbbox
//
//  Created by Peter Bruz on 07/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

final class ShotChangeSynchronizer {
    
    class func synchronize() throws {
        
        do {
            if let shotChanges = try ShotChangeHistoryStorage.allRecords() {
                
                var promise = Promise<Void>()
                
                for change in shotChanges {
                    promise = promise.then {
                        switch change.operationType {
                            case .Like:
                                return ShotOperationRequester.likeShot(change.shotID)
                            case .Unlike:
                                return ShotOperationRequester.unlikeShot(change.shotID)
                            case .AddToBucket:
                                return ShotOperationRequester.addToBucket(change.shotID, bucketID: change.bucketID!)
                            case .RemoveFromBucket:
                                return ShotOperationRequester.removeFromBucket(change.shotID, bucketID: change.bucketID!)
                        }
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
