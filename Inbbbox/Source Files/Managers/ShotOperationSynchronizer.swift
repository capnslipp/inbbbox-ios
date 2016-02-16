//
//  ShotOperationSynchronizer.Swift
//  Inbbbox
//
//  Created by Peter Bruz on 07/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import PromiseKit

final class ShotOperationSynchronizer {
    
    class func synchronize() throws {
        // NGRTemp: Temporary commented-out.
        // Will be refactored because of incoming DB schema changes.

//        do {
//            let shotOperationHistoryStorage = ShotOperationHistoryStorage()
//            
//            if let shotOperations = try shotOperationHistoryStorage.allRecords() {
//                
//                var promise = Promise<Void>()
//                
//                for operation in shotOperations {
//                    promise = promise.then {
//                        switch operation.type {
//                            case .Like:
//                                return ShotOperationRequester.likeShot(operation.shotID)
//                            case .Unlike:
//                                return ShotOperationRequester.unlikeShot(operation.shotID)
//                            case .AddToBucket:
//                                return ShotOperationRequester.addToBucket(operation.shotID, bucketID: operation.bucketID!)
//                            case .RemoveFromBucket:
//                                return ShotOperationRequester.removeFromBucket(operation.shotID, bucketID: operation.bucketID!)
//                        }
//                    }
//                }
//            
//                try shotOperationHistoryStorage.clearHistory()
//                
//                try ShotsLocalStorage().clear()
//            }
//        } catch {
//            throw error
//        }
    }
    
    // NGRTemp: temp name for method that should get buckets' names and ids before logging out in case to add shots to buckets while using as guest
    class func synchronizeBucketsBeforeLogOut() {
        // NGRTodo: get user's buckets
    }
}
