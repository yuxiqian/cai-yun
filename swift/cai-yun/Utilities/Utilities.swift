//
//  Utilities.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/10/1.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation


func intToHex(_ i: Int) -> String {
    return String(format:"%02x", i)
}

func Min(_ i: Double, _ j: Double) -> Double {
    return i < j ? i : j
}

func Max(_ i: Double, _ j: Double) -> Double {
    return i > j ? i : j
}

func rgbToHsl(_ i: [Int]) -> [Double] {
    
    let R: Double = Double(i[0]) / 255.0
    let G: Double = Double(i[1]) / 255.0
    let B: Double = Double(i[2]) / 255.0
    var H: Double = 0.0
    var S: Double = 0.0
    var L: Double = 0.0
    let min = Min(R, Min(G, B))
    let max = Max(R, Max(G, B))
    L = (max + min) / 2.0
    let delta_max: Double = max - min
    if delta_max == 0 {
        H = 0
        S = 0
    } else {
        if L < 0.5 {
            S = delta_max / (max + min)
        } else {
            S = delta_max / (2 - max - min)
        }
        let delta_R: Double = (((max - R) / 6.0) + (delta_max / 2.0)) / delta_max
        let delta_G: Double = (((max - G) / 6.0) + (delta_max / 2.0)) / delta_max
        let delta_B: Double = (((max - B) / 6.0) + (delta_max / 2.0)) / delta_max
        if R == max {
            H = delta_B - delta_G
        } else if G == max {
            H = (1.0 / 3.0) + delta_R - delta_B
        } else if B == max {
            H = (2.0 / 3.0) + delta_G - delta_R
        }
        if H < 0.0 {
            H += 1.0
        } else if H > 1.0 {
            H -= 1.0
        }
    }
    return [round(H * 360), round(S * 1000) / 10.0, round(L * 1000) / 10.0]
}
