//
//  ShotDetailsFormatter.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 23/02/16.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import UIKit.NSAttributedString

final class ShotDetailsFormatter {
    
    static var shotDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        
        return formatter
    }()
    
    static var commentDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.timeStyle = .ShortStyle
        
        return formatter
    }()
    
    class func attributedStringForHeaderFromShot(shot: ShotType) -> NSAttributedString {
        
        let mutableAttributedString = NSMutableAttributedString()
        
        if shot.title.characters.count > 0 {
            
            let titleAttributedString = NSAttributedString(
                string: shot.title,
                attributes: [
                    NSForegroundColorAttributeName : UIColor.blackColor(),
                    NSFontAttributeName : UIFont.boldSystemFontOfSize(15)
            ])
            
            mutableAttributedString.appendAttributedString(titleAttributedString)
            mutableAttributedString.appendAttributedString(NSAttributedString.newLineAttributedString())
        }
        
        let author = (shot.user.name ?? shot.user.username)
        if author.characters.count > 0 {
            
            let prefixString = NSLocalizedString("by", comment: "")
            let authorAttributedString = NSMutableAttributedString(
                string: prefixString + " " + author,
                attributes: [
                    NSForegroundColorAttributeName : UIColor.pinkColor(),
                    NSFontAttributeName : UIFont.systemFontOfSize(14)
            ])
        
            authorAttributedString.setAttributes([
                NSForegroundColorAttributeName : UIColor.grayColor(),
                NSFontAttributeName : UIFont.systemFontOfSize(12)
            ], range: NSMakeRange(0, prefixString.characters.count))
        
            mutableAttributedString.appendAttributedString(authorAttributedString)
            mutableAttributedString.appendAttributedString(NSAttributedString.newLineAttributedString())
        }
        
        if let team = shot.team?.name where team.characters.count > 0 {
            
            let prefixString = NSLocalizedString("for", comment: "")
            let teamAttributedString = NSMutableAttributedString(
                string: prefixString + " " + team,
                attributes: [
                    NSForegroundColorAttributeName : UIColor.pinkColor(),
                    NSFontAttributeName : UIFont.systemFontOfSize(14)
            ])
            
            teamAttributedString.setAttributes([
                NSForegroundColorAttributeName : UIColor.grayColor(),
                NSFontAttributeName : UIFont.systemFontOfSize(12)
            ], range: NSMakeRange(0, prefixString.characters.count))
            
            mutableAttributedString.appendAttributedString(teamAttributedString)
            mutableAttributedString.appendAttributedString(NSAttributedString.newLineAttributedString())
        }
        
        let dateSting = shotDateFormatter.stringFromDate(shot.createdAt)
        if dateSting.characters.count > 0 {
            
            let prefixString = NSLocalizedString("on", comment: "")
            let dateAttributedString = NSAttributedString(
                string: prefixString + " " + dateSting,
                attributes: [
                    NSForegroundColorAttributeName : UIColor.grayColor(),
                    NSFontAttributeName : UIFont.systemFontOfSize(14)
            ])
            
            mutableAttributedString.appendAttributedString(dateAttributedString)
        }
        
        return mutableAttributedString.copy() as! NSAttributedString
    }
    
    class func attributedShotDescriptionFromShot(shot: ShotType) -> NSAttributedString? {
        
        guard let body = shot.attributedDescription?.attributedStringByTrimingNewLineCharactersAtTheEnd() else {
            return nil
        }
        
        let mutableBody = NSMutableAttributedString(attributedString: body)
        
        mutableBody.addAttributes([
            NSForegroundColorAttributeName : UIColor.grayColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(14)
        ], range: NSMakeRange(0, mutableBody.length))
        
        return mutableBody.copy() as? NSAttributedString
    }
    
    class func attributedCommentBodyForComment(comment: CommentType) -> NSAttributedString? {
        
        guard let body = comment.body where body.length > 0 else {
            return nil
        }
        
        let mutableBody = NSMutableAttributedString(attributedString: body.attributedStringByTrimingNewLineCharactersAtTheEnd())
        let range = NSMakeRange(0, mutableBody.length)
        
        mutableBody.addAttributes([
            NSForegroundColorAttributeName : UIColor.grayColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(14)
        ], range: range)
        
        return mutableBody.copy() as? NSAttributedString
    }
    
    class func commentDateForComment(comment: CommentType) -> NSAttributedString {
        return NSAttributedString(string: commentDateFormatter.stringFromDate(comment.createdAt), attributes: [
                NSForegroundColorAttributeName : UIColor.RGBA(164, 180, 188, 1),
                NSFontAttributeName : UIFont.helveticaFont(.Neue, size: 10)
            ])
    }
    
    
    class func commentAuthorForComment(comment: CommentType) -> NSAttributedString {
        return NSAttributedString(string: comment.user.name ?? comment.user.username, attributes: [
                NSForegroundColorAttributeName : UIColor.textDarkColor(),
                NSFontAttributeName : UIFont.helveticaFont(.NeueMedium, size: 16)
            ])
    }
}
