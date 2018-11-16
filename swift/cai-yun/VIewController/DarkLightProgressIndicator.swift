//
//  DarkLightProgressIndicator.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/11/16.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation
import Cocoa

extension NSProgressIndicator {
    
    func switchLight() {
        self.contentFilters = []
    }
    
    func switchDark() {
        let inverseColorFilters = CIFilter(name: "CIColorInvert")!
        self.contentFilters = [inverseColorFilters]
    }
}
