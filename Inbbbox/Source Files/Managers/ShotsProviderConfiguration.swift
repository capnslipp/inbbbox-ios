//
//  ShotsProviderConfiguration.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 22/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class ShotsProviderConfiguration {
    
    enum ShotsSource {
        case NewToday, PopularToday, Debuts, Following
        
        var isActive: Bool {
            switch self {
                case .NewToday: return Settings.StreamSource.NewToday
                case .PopularToday: return Settings.StreamSource.PopularToday
                case .Debuts: return Settings.StreamSource.Debuts
                case .Following: return Settings.StreamSource.Following
            }
        }
    }
    
    var sources: [ShotsSource] {
        return [.NewToday, .PopularToday, .Debuts, .Following].filter { $0.isActive }
    }
    
    func queryByConfigurationForQuery(var query: ShotsQuery, source: ShotsSource) -> ShotsQuery {
    
        switch source {
            case .NewToday:
                query.parameters["sort"] = "recent"
            case .PopularToday:
                break
            case .Debuts:
                query.parameters["list"] = "debuts"
                query.parameters["sort"] = "recent"
            case .Following:
                query.followingUsersShotsQuery = true
        }
    
        return query
    }
}
