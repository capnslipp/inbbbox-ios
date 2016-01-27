//
//  ShotsQuery.swift
//  Inbbbox
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct ShotsQuery: Query {
    
    /// Query definition
    
    let method = Method.GET
    var parameters = Parameters(encoding: .URL)
    private(set) var path = "/shots"
    var followingUsersShotsQuery = false {
        willSet (newValue) {
            path = newValue ? "/user/following/shots" : "/shots"
        }
    }
    
    init() {}
    
    init(user: User) {
        path = "/users/\(user.username)/shots"
    }
    
    
    /// Types
    
    enum List: String {
        case Animated = "animated"
        case Attachments = "attachments"
        case Debuts = "debuts"
        case Playoffs = "playoffs"
        case Rebounds = "rebounds"
        case Teams = "teams"
    }
    
    enum TimeFrame: String {
        case Week = "week"
        case Month = "month"
        case Year = "year"
        case Ever = "ever"
    }
    
    enum Sort: String {
        case Comments = "comments"
        case Recent = "recent"
        case Views = "views"
    }
    
    /// Parameters keys
    
    private enum Key: String {
        case List = "list"
        case Timeframe = "timeframe"
        case Date = "date"
        case Sort = "sort"
    }
    
    /// Parameters accessors
    
    var list: List? {
        get {
            if let listValue = parameters[Key.List.rawValue] as? String {
                return List(rawValue: listValue)
            }
            return nil
        }
        set { parameters[Key.List.rawValue] = newValue?.rawValue }
    }
    
    var timeFrame: TimeFrame? {
        get {
            if let timeFrameValue = parameters[Key.Timeframe.rawValue] as? String {
                return TimeFrame(rawValue: timeFrameValue)
            }
            return nil
        }
        set { parameters[Key.Timeframe.rawValue] = newValue?.rawValue }
    }
    
    var date: NSDate? {
        get {
            if let dateString = parameters[Key.Date.rawValue] as? String {
                return Formatter.Date.Basic.dateFromString(dateString)
            }
            return nil
        }
        set {
            if let newDate = newValue {
                parameters[Key.Date.rawValue] = Formatter.Date.Basic.stringFromDate(newDate)
            }
        }
    }
    
    var sort: Sort? {
        get {
            if let sortValue = parameters[Key.Sort.rawValue] as? String {
                return Sort(rawValue: sortValue)
            }
            return nil
        }
        set { parameters[Key.Sort.rawValue] = newValue?.rawValue }
    }
}
