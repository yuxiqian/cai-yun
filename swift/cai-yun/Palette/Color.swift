//
//  Color.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/10/1.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation

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
    
    var red: Int?
    var green: Int?
    var blue: Int?
    
    var cyan: Int?
    var magenta: Int?
    var yellow: Int?
    var black: Int?
    
    func getHexString() -> String {
        return "#" + intToHex(self.red!) + intToHex(self.green!) + intToHex(self.blue!)
    }
    
    func getHSLDisplay() -> [Double] {
        return rgbToHsl([red!, green!, blue!])
    }
}

