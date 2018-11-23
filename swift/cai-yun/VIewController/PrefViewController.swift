//
//  PrefViewController.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/11/23.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Cocoa

class PrefViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        loadPref()
        if isSourceFount! {
            self.checkBox.state = .on
        } else {
            self.checkBox.state = .off
        }
        
        switch currentStyle {
        case .dark?:
            radioButtonA.state = .on
            break
        case .light?:
            radioButtonB.state = .on
            break
        case .transparent?:
            radioButtonC.state = .on
            break
        default:
            break
        }
    }
    
    let defaults = Defaults()
    let titleKey = Key<titleStyle>("titleKey")
    let fontKey = Key<Bool>("fontKey")
    
    var currentStyle: titleStyle?
    var isSourceFount: Bool?
    
    
    @IBOutlet weak var checkBox: NSButton!
    @IBOutlet weak var radioButtonA: NSButton!
    @IBOutlet weak var radioButtonB: NSButton!
    @IBOutlet weak var radioButtonC: NSButton!
    
    func loadPref() {
        if defaults.has(titleKey) {
            currentStyle = defaults.get(for: titleKey)
        } else {
            defaults.set(.light, for: titleKey)
            currentStyle = .light
        }
        
        if defaults.has(fontKey) {
            isSourceFount = defaults.get(for: fontKey)
        } else {
            defaults.set(true, for: fontKey)
            isSourceFount = true
        }
    }
    
    func savePref() {
        defaults.set(currentStyle!, for: titleKey)
        defaults.set(isSourceFount!, for: fontKey)
    }
    
    @IBAction func switchTitleStyle(_ sender: NSButton) {
        switch sender.title {
        case "暗色":
            currentStyle = .dark
            break
        case "亮色":
            currentStyle = .light
            break
        case "透明":
            currentStyle = .transparent
            break
        default:
            return
        }
    }
    
    @IBAction func switchFont(_ sender: NSButton) {
        isSourceFount = (sender.state == .on)
    }
    
    @IBAction func OKAndClose(_ sender: NSButton) {
        savePref()
        self.view.window?.performClose(self)
    }
    
    @IBAction func Cancel(_ sender: NSButton) {
        self.view.window?.performClose(self)
    }
}

enum titleStyle: Int {
    case dark = 0
    case light = 1
    case transparent = 2
}
