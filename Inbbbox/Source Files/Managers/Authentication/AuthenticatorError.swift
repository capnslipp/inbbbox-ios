//
//  AuthenticatorError.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 21/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum AuthenticatorError: ErrorType {
    case UnableToFetchUser
    case AuthenticationDidCancel
    case DataDecodingFailure
    case AccessTokenMissing
    case AuthTokenMissing
    case UnknownError
}
