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
        formatter.locale = NSLocale.currentLocale()

        return formatter
    }()

    static var commentDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.locale = NSLocale.currentLocale()
        formatter.timeStyle = .ShortStyle

        return formatter
    }()

    class func attributedStringForHeaderWithLinkRangeFromShot(shot: ShotType)
                    -> (attributedString:NSAttributedString, linkRange:NSRange?) {

        let mutableAttributedString = NSMutableAttributedString()
        var userLinkRange: NSRange?

        if shot.title.characters.count > 0 {

            let titleAttributedString = NSAttributedString(
            string: shot.title,
                    attributes: [
                            NSForegroundColorAttributeName: UIColor.blackColor(),
                            NSFontAttributeName: UIFont.boldSystemFontOfSize(15)
                    ])

            mutableAttributedString.appendAttributedString(titleAttributedString)
            mutableAttributedString.appendAttributedString(NSAttributedString.newLineAttributedString())
        }

        let author = (shot.user.name ?? shot.user.username)
        if author.characters.count > 0 {

            let prefixString = NSLocalizedString("ShotDetailsFormatter.By",
                    comment: "Preposition describing author of shot.")
            let authorAttributedString = NSMutableAttributedString(
            string: prefixString + " " + author,
                    attributes: [
                            NSForegroundColorAttributeName: UIColor.pinkColor(),
                            NSFontAttributeName: UIFont.systemFontOfSize(14)
                    ])

            authorAttributedString.setAttributes([
                    NSForegroundColorAttributeName: UIColor.grayColor(),
                    NSFontAttributeName: UIFont.systemFontOfSize(12)
            ], range: NSRange(location: 0, length: prefixString.characters.count)
            )

            userLinkRange = NSRange(location: mutableAttributedString.length + prefixString.characters.count,
                    length: author.characters.count + 1)

            mutableAttributedString.appendAttributedString(authorAttributedString)
            mutableAttributedString.appendAttributedString(NSAttributedString.newLineAttributedString())
        }

        if let team = shot.team?.name where team.characters.count > 0 {

            let prefixString = NSLocalizedString("ShotDetailsFormatter.For",
                    comment: "Preposition describing for who shot was made.")
            let teamAttributedString = NSMutableAttributedString(
            string: prefixString + " " + team,
                    attributes: [
                            NSForegroundColorAttributeName: UIColor.grayColor(),
                            NSFontAttributeName: UIFont.systemFontOfSize(14)
                    ])

            teamAttributedString.setAttributes([
                    NSForegroundColorAttributeName: UIColor.grayColor(),
                    NSFontAttributeName: UIFont.systemFontOfSize(12)
            ], range: NSRange(location: 0, length: prefixString.characters.count))

            mutableAttributedString.appendAttributedString(teamAttributedString)
            mutableAttributedString.appendAttributedString(NSAttributedString.newLineAttributedString())
        }

        let dateSting = shotDateFormatter.stringFromDate(shot.createdAt)
        if dateSting.characters.count > 0 {

            let prefixString = NSLocalizedString("ShotDetailsFormatter.On",
                    comment: "Preposition describing when shot was made.")
            let dateAttributedString = NSAttributedString(
            string: prefixString + " " + dateSting,
                    attributes: [
                            NSForegroundColorAttributeName: UIColor.grayColor(),
                            NSFontAttributeName: UIFont.systemFontOfSize(14)
                    ])

            mutableAttributedString.appendAttributedString(dateAttributedString)
        }

        return (mutableAttributedString.copy() as! NSAttributedString, userLinkRange)
    }

    class func attributedShotDescriptionFromShot(shot: ShotType) -> NSAttributedString? {

        guard let body = shot.attributedDescription?.attributedStringByTrimingNewLineCharactersAtTheEnd() else {
            return nil
        }

        let mutableBody = NSMutableAttributedString(attributedString: body)

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.maximumLineHeight = 20
        style.minimumLineHeight = 20

        mutableBody.addAttributes([
                NSForegroundColorAttributeName: UIColor.grayColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(15),
                NSParagraphStyleAttributeName: style
        ], range: NSRange(location: 0, length: mutableBody.length))

        return mutableBody.copy() as? NSAttributedString
    }

    class func attributedCommentBodyForComment(comment: CommentType) -> NSAttributedString? {

        guard let body = comment.body where body.length > 0 else {
            return nil
        }

        let mutableBody = body.attributedStringByTrimingNewLineCharactersAtTheEnd().mutableCopy()
        let range = NSRange(location: 0, length: mutableBody.length)

        mutableBody.addAttributes([
                NSForegroundColorAttributeName: UIColor.grayColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(14)
        ], range: range)

        return mutableBody.copy() as? NSAttributedString
    }

    class func commentDateForComment(comment: CommentType) -> NSAttributedString {
        return NSAttributedString(string: commentDateFormatter.stringFromDate(comment.createdAt), attributes: [
                NSForegroundColorAttributeName: UIColor.RGBA(164, 180, 188, 1),
                NSFontAttributeName: UIFont.helveticaFont(.Neue, size: 10)
        ])
    }

    class func commentAuthorForComment(comment: CommentType) -> NSAttributedString {
        return NSAttributedString(string: comment.user.name ?? comment.user.username, attributes: [
                NSForegroundColorAttributeName: UIColor.textDarkColor(),
                NSFontAttributeName: UIFont.helveticaFont(.NeueMedium, size: 16)
        ])
    }
}
