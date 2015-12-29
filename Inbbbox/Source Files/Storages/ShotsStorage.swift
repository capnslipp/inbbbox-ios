//
//  ShotsStorage.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 28/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

struct ShotsStorage {
    
    var shotsFromAssetCatalog: [UIImage] {
        
        let assetsEnumarator = (min: 1, max: 16)
        var images = [UIImage]()
        
        for index in assetsEnumarator.min...assetsEnumarator.max {
            if let image = UIImage(named: ("shot-" + String(index))) {
                images.append(image)
            }
        }
        
        return images
    }
}
