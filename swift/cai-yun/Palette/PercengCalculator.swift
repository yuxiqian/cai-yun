//
//  PercengCalculator.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/10/1.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation

func toPercent(value: Int, type: ExpTypes) -> Double {
    switch type {
    case .RGB:
        return Double(value) / 255.0
    case .CMYK:
        return Double(value) / 100.0
    }
}
