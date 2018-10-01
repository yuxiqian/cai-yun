//
//  MainViewController.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/9/30.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Cocoa
import SwiftyJSON

class MainViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let font = NSFont(name: "SourceHanSerifCN-Light", size: CGFloat(24))
        // Do any additional setup after loading the view.
        let chinese = loadResources(Palette.chineseColors)
        let nippon = loadResources(Palette.nipponColors)

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
