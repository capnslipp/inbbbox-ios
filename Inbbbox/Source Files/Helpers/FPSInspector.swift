//
//  FPSInspector.swift
//  Inbbbox
//
//  Created by Lukasz Pikor on 04.10.2016.
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import WatchdogInspector

final class FPSInspector {
    class func startInspectingIfNecessary() {
        #if ENV_DEVELOPMENT || ENV_STAGING
            TWWatchdogInspector.setEnableMainthreadStallingException(false)
            TWWatchdogInspector.start()
        #endif
    }
}
