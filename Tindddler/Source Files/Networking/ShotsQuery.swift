//
//  ShotsQuery.swift
//  Tindddler
//
//  Created by Radoslaw Szeja on 14/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct ShotsQuery: Query {
    
    /// Query definition
    
    let method = Method.GET
    let path  = "/shots"
    let service: SecureNetworkService = DribbbleNetworkService()
    var parameters = Parameters(encoding: .URL)
    
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
        get { return List(rawValue: parameters[Key.List.rawValue] as! String) }
        set { parameters[Key.List.rawValue] = newValue?.rawValue }
    }
    
    var timeFrame: TimeFrame? {
        get { return TimeFrame(rawValue: parameters[Key.Timeframe.rawValue] as! String) }
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
        get { return Sort(rawValue: parameters[Key.Sort.rawValue] as! String) }
        set { parameters[Key.Sort.rawValue] = newValue?.rawValue }
    }
}
