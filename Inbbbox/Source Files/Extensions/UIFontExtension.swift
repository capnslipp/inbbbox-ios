//
//  UIFontExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 29/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum Helvetica {
        case Neue, NeueMedium, NeueLight
        
        var name: String {
            switch self {
                case .Neue: return "HelveticaNeue"
                case .NeueMedium: return "HelveticaNeue-Medium"
                case .NeueLight: return "HelveticaNeue-Light"
            }
        }
    }
    
    class func helveticaFont(type: Helvetica, size: CGFloat = UIFont.systemFontSize()) -> UIFont {
        return UIFont(name: type.name, size: size)!
    }
}
