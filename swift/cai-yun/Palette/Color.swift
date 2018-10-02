//
//  Color.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/10/1.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation
import Cocoa

class Color {
    
    init(Name: String, Alias: String,
              _ r: Int, _ g: Int, _ b: Int,
              _ c: Int, _ m: Int, _ y: Int, _ k: Int) {
        
        self.name = Name
        self.aliasName = Alias
        
        self.red = r
        self.green = g
        self.blue = b
        
        self.cyan = c
        self.magenta = m
        self.yellow = y
        self.black = k
    }
    
    
    
    var name: String?
    var aliasName: String?
    
    var red: Int = 0
    var green: Int = 0
    var blue: Int = 0
    
    var cyan: Int = 0
    var magenta: Int = 0
    var yellow: Int = 0
    var black: Int = 0
    

    func getRGBString() -> String {
        return "红：" + String(format:"  %03d", self.red)
            + "\t绿：" + String(format:"  %03d", self.green)
            + "\t蓝：" + String(format:"  %03d", self.blue)
    }
    
    func getCMYKString() -> String {
        return "青：" + String(format:"  %03d", self.cyan)
            + "\t品：" + String(format:"  %03d", self.magenta)
            + "\t黄：" + String(format:"  %03d", self.yellow)
            + "\t黑：" + String(format:"  %03d", self.black)
    }
    
    func getHSLString() -> String {
        let hsl = self.getHSLDisplay()
        return "色：" + String(format:"%05.1f", hsl[0])
            + "\t饱：" + String(format:"%05.1f", hsl[1])
            + "\t明：" + String(format:"%05.1f", hsl[2])
    }
    
    func getHexString() -> String {
        return "#" + intToHex(self.red) + intToHex(self.green) + intToHex(self.blue)
    }
    
    func getHSLDisplay() -> [Double] {
        return rgbToHsl([red, green, blue])
    }
    
    func getNSColor() -> NSColor {
        return NSColor(calibratedRed: CGFloat(self.red) / 255.0,
                       green: CGFloat(self.green) / 255.0,
                       blue: CGFloat(self.blue) / 255.0,
                       alpha: 1.0)
    }
    
    func getTextColor() -> NSColor {
        let grayIndex =
            0.212671 * Double(self.red) +
            0.715160 * Double(self.green) +
            0.072169 * Double(self.blue)
        if grayIndex > 127 {
            return NSColor(calibratedWhite: 0.0, alpha: 1.0)
        } else {
            return NSColor(calibratedWhite: 1.0, alpha: 1.0)
        }
    }
    
    func shouldShowDark() -> Bool {
        let grayIndex =
            0.212671 * Double(self.red) +
                0.715160 * Double(self.green) +
                0.072169 * Double(self.blue)
        if grayIndex > 127 {
            return false
        } else {
            return true
        }
    }
    
    func getAccentColor() -> NSColor {
        return NSColor(calibratedRed: suitableColor(self.red),
                       green: suitableColor(self.green),
                       blue: suitableColor(self.blue),
                       alpha: 1.0)
    }
    
    func getTitleImage(width: Int, height: Int) -> NSImage {
        let deepColor = NSColor(calibratedRed: suitableColor(self.red),
                       green: suitableColor(self.green),
                       blue: suitableColor(self.blue),
                       alpha: 1.0)
        return NSImage(color: deepColor, size: NSSize(width: width, height: height))
    }
}
