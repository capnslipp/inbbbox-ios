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
    /// When user is **not** authenticated, then limit is uknown due to client access token usage.
    /// Inbbbox will use own client access token which is available globally for other Inbbbox aplications installed on other devices.
    var rateLimitPerDay: UInt? {
        return TokenStorage.currentToken != nil ?
            Dribbble.RequestPerDayLimitForAuthenticatedUser : nil
    }
    
    /// Number of api hits remaining during current minute.
    /// The number is unknown when api request wasn't sent previously.
    private(set) var rateLimitRemainingPerMinute: UInt?
    
    /// Number of api hits remaining during current day.
    /// The number is unknown if user is not currently logged in.
    private(set) var rateLimitRemainingPerDay: UInt? {
        get {
            if let value = Defaults[DailyRateLimitRemainingKey].int {
                return UInt(value)
            }
            return  nil
        }
        set {
            Defaults[DailyRateLimitRemainingKey] = newValue != nil ? Int(newValue!) : nil
        }
    }
    
    /// Time left to reset remaining minute rate limit.
    private(set) var timeIntervalRemainingToResetMinuteLimit: NSTimeInterval?
    
    /// Time left to reset remaining daily rate limit.
    var timeIntervalRemainingToResetDailyLimit: NSTimeInterval {
        
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
        
        if let interval = integerFromHeader(header, forKey: XRateLimitReset) {
            
            let previousTimeIntervalRemainingToResetMinuteLimit = timeIntervalRemainingToResetMinuteLimit
            
            timeIntervalRemainingToResetMinuteLimit = {
                let resetDate = NSDate(timeIntervalSince1970: NSTimeInterval(interval))
                return max(resetDate.timeIntervalSinceNow, 0)
            }()
            
            // Checks whether API respond with greater value of time needed to reset than stored one.
            // If yes then sets remaining rate limit to  default one.
            let isNewMinuteSlotForSendingRequest = previousTimeIntervalRemainingToResetMinuteLimit < timeIntervalRemainingToResetMinuteLimit
            if isNewMinuteSlotForSendingRequest {
                rateLimitRemainingPerMinute = rateLimitPerMinute
            }
            
            // Checks whether incoming request contains lower value for XRateLimitRemaining than stored one in current request minute slot.
            // If yes then assign them to stored one. Otherwise do nothing.
            let incomingRateLimitRemainingPerMinute = integerFromHeader(header, forKey: XRateLimitRemaining)
            if incomingRateLimitRemainingPerMinute < rateLimitRemainingPerMinute {
                rateLimitRemainingPerMinute = incomingRateLimitRemainingPerMinute
            }
        }
    }
    
    /**
     Verifies daily rate limit from response.
     
     - parameter response: Response to verify.
     
     - throws: APIRateLimitKeeperError.DidExceedRateLimitPerDay error with time interval remaining to reset daily limit as parameter.
     */
    func verifyResponseForRateLimitation(response: NSURLResponse?) throws {
        
        if let response = response as? NSHTTPURLResponse where response.statusCode == 429 {
            throw APIRateLimitKeeperError.DidExceedRateLimitPerDay(timeIntervalRemainingToResetDailyLimit)
        }
    }
    
    /**
     Verifies rate limit. Throws with APIRateLimitKeeperError if limit is known and exceeded.
     */
    func verifyRateLimit() throws {
        
        if var perDayRemainingLimit = rateLimitRemainingPerDay {
            rateLimitRemainingPerDay = perDayRemainingLimit--
        }
        
        if let limit = rateLimitRemainingPerDay where limit <= 0 {
            throw APIRateLimitKeeperError.DidExceedRateLimitPerDay(self.timeIntervalRemainingToResetDailyLimit ?? 0)
        }
        
        if let limit = rateLimitRemainingPerMinute where limit <= 1 {
            throw APIRateLimitKeeperError.DidExceedRateLimitPerMinute(self.timeIntervalRemainingToResetMinuteLimit ?? 0)
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
