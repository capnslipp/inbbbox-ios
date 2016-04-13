//
//  APIShotsProviderConfiguration.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 22/01/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class APIShotsProviderConfiguration {

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

    func queryByConfigurationForQuery(query: ShotsQuery, source: ShotsSource) -> ShotsQuery {
        var resultQuery = query
        switch source {
            case .NewToday:
                resultQuery.parameters["sort"] = "recent"
            case .PopularToday:
                break
            case .Debuts:
                resultQuery.parameters["list"] = "debuts"
                resultQuery.parameters["sort"] = "recent"
            case .Following:
                resultQuery.followingUsersShotsQuery = true
        }

        resultQuery.date = NSDate()

        return resultQuery
    }
}
