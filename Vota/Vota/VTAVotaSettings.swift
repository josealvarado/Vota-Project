//
//  VTAVotaSettings.swift
//  Vota
//
//  Created by Jose Alvarado on 6/14/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAVotaSettings {

    static let sharedInstance = VTAVotaSettings()
    
    enum TargetView {
        case Home
        case Search
        case Info
        case Profile
    }
    
    var targetView = TargetView.Home
}
