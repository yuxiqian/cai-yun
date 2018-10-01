//
//  ResourceReader.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/10/1.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation
import SwiftyJSON

func loadResources(_ palette: Palette)  {
    let path = Bundle.main.path(forResource: "resources/\(palette.rawValue)", ofType: "json")

    if let jsonPath = path {
        let jsonData = NSData(contentsOfFile: jsonPath)
        do {
            let j = try JSON(data: jsonData! as Data)
//            print(String(data: jsonData! as Data, encoding: .utf8) ?? "No json found.")
        } catch {
            return
        }
    }
}


enum Palette: String {
    case chineseColors = "chinese_colors"
    case nipponColors = "nippon_colors"
}
