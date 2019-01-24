//
//  Utilities.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/10/1.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation
import Cocoa

func getRandom(_ min: Int, _ max: Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

func getFont(_ points: Points, _ fallback: Bool) -> NSFont? {
    if fallback {
        return NSFont(name: "PingFangSC-Regular", size: CGFloat(points.rawValue))
    }
    return NSFont(name: "SourceHanSerifCN-Light", size: CGFloat(points.rawValue))
}

func intToHex(_ i: Int) -> String {
    return String(format:"%02x", i)
}

func Min(_ i: Double, _ j: Double) -> Double {
    return i < j ? i : j
}

func Max(_ i: Double, _ j: Double) -> Double {
    return i > j ? i : j
}

func suitableColor(_ int: Int) -> CGFloat {
    /*
        if #available(OSX 10.14, *) {
            let appear = NSApplication.shared.effectiveAppearance
            if appear.name == .aqua {
                return (pow(CGFloat(int) / 255.0, 2.0) * 0.5 + 0.5)
            } else {
                return (pow(CGFloat(int) / 255.0, 2.0) * 0.5)
            }
        } else {
     */
        return (pow(CGFloat(int) / 255.0, 2.0) * 0.5 + 0.5)
    /* } */
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

func fixSpelling(_ str: String?) -> String {
    if str == nil || str == "" {
        return ""
    }

    let result = str!.uppercased().prefix(1) + str!.suffix(str!.count - 1)
    return result.replacingOccurrences(of: "v", with: "yu")
}



extension NSImage {
    convenience init(color: NSColor, size: NSSize) {
        self.init(size: size)
        lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        self.draw(in: NSRect(origin: .zero, size: size),
                  from: NSRect(origin: .zero, size: self.size),
                  operation: .color, fraction: 1)
        unlockFocus()
    }
}

extension CGPoint {
    func addOffset(_ type: pixelOffset) -> CGPoint {
        var newPoint = self
        switch type {
        case .bothXandY:
            newPoint.x -= 2
            newPoint.y -= 2
            return newPoint
        case .Xonly:
            newPoint.x -= 2
            return newPoint
        case .Yonly:
            newPoint.y -= 2
            newPoint.x -= 1
            return newPoint
        }
    }
}
