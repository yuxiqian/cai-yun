//
//  AcknowledgementsViewController.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/10/1.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Cocoa

class AcknowledgementsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func shutWindow(_ sender: NSButton) {
        self.view.window?.close()
    }
    
}
