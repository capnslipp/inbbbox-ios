//
//  APIRateLimitKeeper.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 16/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

private let XRateLimit = "X-RateLimit-Limit"
private let XRateLimitRemaining = "X-RateLimit-Remaining"
private let XRateLimitReset = "X-RateLimit-Reset"
private let DailyRateLimitRemainingKey = "DailyRateLimitRemainingKey"

/**
 Error related to rate limit of API.
 
 - DidExceedRateLimitPerMinute: Occurs when application did perform more than 60 hits to API per minute.
                                Provides time left to reset as parameter.
 - DidExceedRateLimitPerDay:    Occurs when application did perform to many hits to API per day.
                                Provides time left to reset as parameter.
 */
enum APIRateLimitKeeperError: ErrorType {
    case DidExceedRateLimitPerMinute(NSTimeInterval)
    case DidExceedRateLimitPerDay(NSTimeInterval)
}

/// Protects against exceeding the API limit.
final class APIRateLimitKeeper {
    
    /// Minute rate limit.
    private(set) var rateLimitPerMinute: UInt?
    
    /// Daily rate limit.
    /// When user is **not** authenticated, there is no possibility to define rateLimitPerDay for app.
    /// Inbbbox will use own client access token which is available globally for other Inbbbox aplications installed on other devices.
    var rateLimitPerDay: UInt {
        return TokenStorage.currentToken != nil ?
            Dribbble.RequestPerDayLimitForAuthenticatedUser :
            UInt.max
    }
    
    /// Number of api hits remaining within current minute.
    private(set) var rateLimitRemainingPerMinute: UInt?
    
    /// Number of api hits remaining within current day.
    private(set) var rateLimitRemainingPerDay: UInt {
        get { return UInt(Defaults[DailyRateLimitRemainingKey].int ?? UInt.max) }
        set { Defaults[DailyRateLimitRemainingKey] = Int(newValue) }
    }
    
    /// Time left to reset remaining minute rate limit.
    private(set) var timeRemainingToResetMinuteLimit: NSTimeInterval?
    
    /// Time left to reset remaining daily rate limit.
    var timeRemainingToResetDailyLimit: NSTimeInterval {
        
        let oneDayTimeInterval = NSTimeInterval(60*60*24)
        let startOfNextDay = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.startOfDayForDate(NSDate(timeIntervalSinceNow: oneDayTimeInterval))
        
        return startOfNextDay.timeIntervalSinceDate(NSDate())
    }
    
    /// Shared instance.
    static let sharedKeeper = APIRateLimitKeeper()
    
    /**
     Sets limitation according to information from given header.
     
     - parameter header: Header which will be used to obtain the limits.
     */
    func setCurrentLimitFromHeader(header: [String: AnyObject]) {
        
        rateLimitPerMinute = integerFromHeader(header, forKey: XRateLimit)
        rateLimitRemainingPerMinute = integerFromHeader(header, forKey: XRateLimitRemaining)
        
        if let interval = integerFromHeader(header, forKey: XRateLimitReset) {
            timeRemainingToResetMinuteLimit = {
                let resetDate = NSDate(timeIntervalSince1970: NSTimeInterval(interval))
                return max(resetDate.timeIntervalSinceNow, 0)
            }()
        }
    }
    
    /**
     Verifies daily rate limit from response.
     
     - parameter response: Response to verify.
     
     - throws: APIRateLimitKeeperError.DidExceedRateLimitPerDay error with time remaining to reset daily limit as parameter.
     */
    func verifyResponseForRateLimitation(response: NSURLResponse?) throws {
        
        if let response = response as? NSHTTPURLResponse where response.statusCode == 429 {
            throw APIRateLimitKeeperError.DidExceedRateLimitPerDay(timeRemainingToResetDailyLimit)
        }
    }
    
    /**
     Verifies rate limit. Throws with APIRateLimitKeeperError if limit is known and exceeded.
     */
    func verifyRateLimit() throws {
        
        rateLimitRemainingPerDay--
        
        if rateLimitRemainingPerDay <= 0 {
            throw APIRateLimitKeeperError.DidExceedRateLimitPerDay(self.timeRemainingToResetDailyLimit ?? 0)
        }
        
        if let limit = timeRemainingToResetMinuteLimit where limit <= 0 {
            throw APIRateLimitKeeperError.DidExceedRateLimitPerMinute(self.timeRemainingToResetMinuteLimit ?? 0)
        }
    }
}

private extension APIRateLimitKeeper {
    
    func integerFromHeader(header: [String: AnyObject], forKey key: String) -> UInt? {
        if let stringValue = header[key] as? String, uintValue = UInt(stringValue) {
            return uintValue
        }
        return nil
    }
}
