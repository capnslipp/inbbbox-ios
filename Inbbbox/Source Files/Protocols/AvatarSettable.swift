//
//  AvatarSettable.swift
//  Inbbbox
//
//  Created by Aleksander Popko on 15.02.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol AvatarSettable {

    var avatarView: AvatarView! { get }
    var avatarSize: CGSize { get }

    func setupAvatar()

}
