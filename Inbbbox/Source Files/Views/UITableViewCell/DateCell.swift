//
//  DateCell.swift
//  Inbbbox
//
//  Created by Peter Bruz on 18/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import PureLayout

class DateCell: UITableViewCell, Reusable {

    class var reuseIdentifier: String {
        return "TableViewDateCellReuseIdentifier"
    }

    let dateLabel = UILabel.newAutoLayoutView()

    private var didSetConstraints = false

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .DisclosureIndicator

        dateLabel.textColor = UIColor.followeeTextGrayColor()
        dateLabel.textAlignment = .Right
        contentView.addSubview(dateLabel)

        setNeedsUpdateConstraints()
    }

    @available(*, unavailable, message="Use init(style:reuseIdentifier:) method instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if !didSetConstraints {
            didSetConstraints = true

            dateLabel.autoPinEdgeToSuperviewEdge(.Trailing)
            dateLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 12)
            dateLabel.autoSetDimensionsToSize(CGSize(width: 80, height: 21))
        }

        super.updateConstraints()
    }

    func setDateText(text: String) {
        dateLabel.text = text
    }
}
