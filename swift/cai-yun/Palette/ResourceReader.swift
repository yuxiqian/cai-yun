//
//  ResourceReader.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/10/1.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Foundation
import SwiftyJSON

func loadResources(_ palette: Palette) -> [Color] {
    let path = Bundle.main.path(forResource: "resources/\(palette.rawValue)", ofType: "json")

    if let jsonPath = path {
        let jsonData = NSData(contentsOfFile: jsonPath)
        do {
            let paletteJson = try JSON(data: jsonData! as Data)
            var palette: [Color] = []
            for color in paletteJson["color"].array! {
                palette.append(Color(Name: color["name"].stringValue, Alias: color["alias_name"].stringValue,
                                     color["r"].intValue, color["g"].intValue, color["b"].intValue,
                                     color["c"].intValue, color["m"].intValue, color["y"].intValue, color["k"].intValue))
            }
            return palette
        } catch {
            return []
        }
    }
    return []
}


