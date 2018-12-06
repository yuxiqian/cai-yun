//
//  PreferenceWindowController.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/12/6.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Cocoa

class PreferenceWindowController: NSWindowController {
    
    override func windowDidLoad() {
        toolBar.selectedItemIdentifier = generalItem.itemIdentifier
        super.windowDidLoad()
    }
    
    @IBOutlet weak var toolBar: NSToolbar!
    @IBOutlet weak var generalItem: NSToolbarItem!
    
    @IBAction func switchToDisplay(_ sender: NSToolbarItem) {
        (self.window?.contentViewController as! PrefViewController).switchToDisplay()
    }
    
    @IBAction func switchToGeneral(_ sender: NSToolbarItem) {
        (self.window?.contentViewController as! PrefViewController).switchToGeneral()
    }
}
