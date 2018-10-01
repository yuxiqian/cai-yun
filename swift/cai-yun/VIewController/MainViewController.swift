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
    
    var palettes = [String: [Color]]()
    var currentPalette: [Color] = []
    var currentColor: Color?
    var isNextTap = false
    var isRGBAndNotCMYK = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.window?.isMovableByWindowBackground = true
        
        // Do any additional setup after loading the view.
        
        loadPalette()
        setFont()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if !isNextTap {
            shuffleNextColor()
        }
        isNextTap = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        isNextTap = true
    }
    
    override func viewWillLayout() {
        if currentColor != nil {
            setColorDisplay()
        }
    }
    
    
    @IBOutlet weak var titleShadowBar: NSImageView!
    @IBOutlet weak var mainNameTitle: NSTextField!
    @IBOutlet weak var aliasNameTitle: NSTextField!
    @IBOutlet weak var ringOne: NSProgressIndicator!
    @IBOutlet weak var ringTwo: NSProgressIndicator!
    @IBOutlet weak var ringThree: NSProgressIndicator!
    @IBOutlet weak var ringFour: NSProgressIndicator!
    
    
    
    func loadPalette() {
        
        let chinese = loadResources(Palette.chineseColors)
        let nippon = loadResources(Palette.nipponColors)
        
        palettes[Palette.chineseColors.rawValue] = chinese
        palettes[Palette.nipponColors.rawValue] = nippon
        
        switchPalette()
    }
    
    func switchPalette() {
        if /* 选择了中国色 */ true {
            currentPalette = palettes[Palette.chineseColors.rawValue]!
        } else {
            currentPalette = palettes[Palette.nipponColors.rawValue]!
        }
    }
    
    func switchColorDisplay() {
        isRGBAndNotCMYK = !isRGBAndNotCMYK
        if isRGBAndNotCMYK {
            ringOne.isHidden = true
        } else {
            ringOne.isHidden = false
        }
    }
    
    func setFont() {
        self.mainNameTitle.font = getFont(.mainName)
        self.aliasNameTitle.font = getFont(.aliasName)
    }
    
    func setColorDisplay() {
        if self.currentColor != nil {
            self.mainNameTitle.stringValue = self.currentColor!.name ?? "__COLOR_NAME__"
            self.mainNameTitle.textColor = self.currentColor!.getTextColor()
            
            self.aliasNameTitle.stringValue = fixSpelling(self.currentColor!.aliasName)
            self.aliasNameTitle.textColor = self.currentColor!.getTextColor()
            
            self.view.window?.backgroundColor = self.currentColor!.getNSColor()
            self.titleShadowBar.image = self.currentColor!.getTitleImage(width: Int(self.view.frame.width), height: 20)
        }
    }
    
    func shuffleNextColor() {
        NSLog("Should shuffle next color.")
        let count = currentPalette.count
        
        if count != 0 {
            var nextColor: Color? = currentPalette[getRandom(0, count - 1)]
            if self.currentColor != nil {
                while nextColor!.name == self.currentColor!.name {
                    nextColor = (currentPalette[getRandom(0, count - 1)])
                }
            }
            self.currentColor = nextColor
        }
        setColorDisplay()
    }
}
