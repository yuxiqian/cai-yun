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
        registerDefaultPrefs()
        loadPref()
        setUI()
        
    }
    
    weak var delegate: updatePrefDelegate?
    
    var currentStyle: titleStyle?
    var isSourceFont: Bool?
    
    let userDefaults = UserDefaults.standard
    
    let fileName: [String] = ["dark", "light", "transparent"]
    
    @IBOutlet weak var checkBox: NSButton!
    @IBOutlet weak var radioButtonA: NSButton!
    @IBOutlet weak var radioButtonB: NSButton!
    @IBOutlet weak var radioButtonC: NSButton!
    @IBOutlet weak var sampleCell: NSImageView!
    
    fileprivate func registerDefaultPrefs() {
        let defaultPreferences: [String: Any] = [
            PreferenceKey.titleStyleTheme: titleStyle.light.rawValue,
            PreferenceKey.useSourceFont: true,
            ]
        userDefaults.register(defaults: defaultPreferences)
    }
    
//    
    fileprivate func loadPref() {
        if let style = titleStyle.init(rawValue: userDefaults.integer(forKey: PreferenceKey.titleStyleTheme)) {
            currentStyle = style
        } else {
            currentStyle = .light
        }
        isSourceFont = userDefaults.bool(forKey: PreferenceKey.useSourceFont)
    }
    
    fileprivate func savePrefs() {
        userDefaults.set(currentStyle?.rawValue, forKey: PreferenceKey.titleStyleTheme)
        userDefaults.set(isSourceFont, forKey: PreferenceKey.useSourceFont)
    }
    
    fileprivate func setUI() {
        if isSourceFont! {
            checkBox.state = .on
        } else {
            checkBox.state = .off
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
        updateExample()
    }
    
    fileprivate func updateExample() {
        let path = Bundle.main.path(forResource: "resources/\(fileName[(currentStyle?.rawValue)!])", ofType: "png")
        let imgData = NSImage(data: NSData(contentsOfFile: path!)! as Data)
        sampleCell.image = imgData
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
        
        updateExample()
    }
    
    @IBAction func switchFont(_ sender: NSButton) {
        isSourceFont = (sender.state == .on)
    }
    
    @IBAction func OKAndClose(_ sender: NSButton) {
        savePrefs()
        self.delegate?.updatePreference()
        self.view.window?.close()
    }
    
    @IBAction func Cancel(_ sender: NSButton) {
        self.view.window?.close()
    }
}

enum titleStyle: Int {
    case dark = 0
    case light = 1
    case transparent = 2
}


struct PreferenceKey {
    static let titleStyleTheme = "titleStyleTheme"
    static let useSourceFont = "useSourceFont"
}


