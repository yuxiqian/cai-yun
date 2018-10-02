//
//  Constants.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/10/1.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation

enum Palette: String {
    case chineseColors = "chinese_colors"
    case nipponColors = "nippon_colors"
    case metroColors = "metro_line_colors"
    //    case additionColors = "addition_colors"
}

enum Points: Int {
    case mainName = 36
    case aliasName = 24
    case numbers = 20
    case copyrightText = 14
}

enum ExpTypes {
    case RGB
    case CMYK
}

enum pixelOffset {
    
    case bothXandY
    case Yonly
    case Xonly
//    case C = [-1, -1]
//    case M = [0, -1]
//    case Y = [-1, -1]
//    case K = [-1, -1]
//
//    case R = [0, -1]
//    case G = [-1, -1]
//    case B = [0, -1]
}

