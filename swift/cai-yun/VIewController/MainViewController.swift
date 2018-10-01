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
    var isRGBAndNotCMYK = false
    
    var moreMenu = NSMenu()
    var paletteMenu = NSMenu()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.window?.isMovableByWindowBackground = true
        
        paletteMenu.addItem(withTitle: "中国色", action: #selector(switchToChineseColors(_:)), keyEquivalent: "s")
        paletteMenu.addItem(withTitle: "日本の伝統色", action: #selector(switchToNipponColors(_:)), keyEquivalent: "n")
        moreMenu.title = "更多选项"
        moreMenu.addItem(withTitle: "改用 CMYK 表示", action: #selector(switchColorDisplay(_:)), keyEquivalent: "s")
        moreMenu.addItem(withTitle: "选择调色板", action: #selector(releaseUI(_:)), keyEquivalent: "")
        moreMenu.setSubmenu(paletteMenu, for: moreMenu.item(withTitle: "选择调色板")!)
        moreMenu.addItem(withTitle: "致谢", action: #selector(showAcknowledgements(_:)), keyEquivalent: "a")
        moreButton.menu = moreMenu
        
        
        loadPalette()
        setFont()
        shuffleNextColor()
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
    
    
    @IBOutlet weak var CLabel: NSTextField!
    @IBOutlet weak var MLabel: NSTextField!
    @IBOutlet weak var YLabel: NSTextField!
    @IBOutlet weak var KLabel: NSTextField!
    
    @IBOutlet weak var RLabel: NSTextField!
    @IBOutlet weak var GLabel: NSTextField!
    @IBOutlet weak var BLabel: NSTextField!
    
    @IBOutlet weak var moreButton: NSButton!
    
    @IBAction func moreButtonClicked(_ sender: NSButton) {
        self.isNextTap = true
        let p = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y)
        self.moreMenu.popUp(positioning: self.moreMenu.item(at: 0), at: p, in: self.view)
    }
    
    @objc func showAcknowledgements(_ sender: NSStatusItem) {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Acknowledgements Controller")) as! NSWindowController
        
        if let window = windowController.window {
            self.view.window?.beginSheet(window, completionHandler: nil)
        }
        self.isNextTap = false
    }
    
    
    func loadPalette() {
        
        let chinese = loadResources(Palette.chineseColors)
        let nippon = loadResources(Palette.nipponColors)
        
        palettes[Palette.chineseColors.rawValue] = chinese
        palettes[Palette.nipponColors.rawValue] = nippon
        
        switchPalette(Palette.chineseColors)
        
        switchColorDisplay(NSMenuItem())
        switchToChineseColors(NSMenuItem())
    }
    
    func switchPalette(_ palette: Palette) {
        
        currentPalette = palettes[palette.rawValue]!
        
        shuffleNextColor()
    }
    
    @objc func releaseUI(_ sender: NSMenuItem) {
        self.isNextTap = false
    }
    
    @objc func switchToChineseColors(_ sender: NSMenuItem) {
        if paletteMenu.item(withTitle: "中国色")!.state == .on {
            return
        }
        
        switchPalette(.chineseColors)
        isNextTap = false
        
        paletteMenu.item(withTitle: "中国色")!.state = .on
        paletteMenu.item(withTitle: "日本の伝統色")!.state = .off
    }
    
    @objc func switchToNipponColors(_ sender: NSMenuItem) {
        if paletteMenu.item(withTitle: "日本の伝統色")!.state == .on {
            return
        }
        switchPalette(.nipponColors)
        isNextTap = false
        
        paletteMenu.item(withTitle: "中国色")!.state = .off
        paletteMenu.item(withTitle: "日本の伝統色")!.state = .on
    }
    
    @objc func switchColorDisplay(_ sender: NSMenuItem) {
        isRGBAndNotCMYK = !isRGBAndNotCMYK
        if isRGBAndNotCMYK {
            ringOne.isHidden = true
            ringTwo.maxValue = 255
            ringThree.maxValue = 255
            ringFour.maxValue = 255
            
            moreMenu.item(withTitle: "改用 RGB 表示")?.title = "改用 CMYK 表示"
            
            CLabel.isHidden = true
            MLabel.isHidden = true
            YLabel.isHidden = true
            KLabel.isHidden = true
            RLabel.isHidden = false
            GLabel.isHidden = false
            BLabel.isHidden = false
            
        } else {
            ringOne.isHidden = false
            ringTwo.maxValue = 100
            ringThree.maxValue = 100
            ringFour.maxValue = 100
            
            moreMenu.item(withTitle: "改用 CMYK 表示")?.title = "改用 RGB 表示"
            
            CLabel.isHidden = false
            MLabel.isHidden = false
            YLabel.isHidden = false
            KLabel.isHidden = false
            RLabel.isHidden = true
            GLabel.isHidden = true
            BLabel.isHidden = true
        }
        self.isNextTap = false
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
            
            if isRGBAndNotCMYK {
                // RGB Mode
//                self.ringTwo.doubleValue = Double((self.currentColor?.red)!)
//                self.ringThree.doubleValue = Double((self.currentColor?.green)!)
//                self.ringFour.doubleValue = Double((self.currentColor?.blue)!)
                
                
                self.ringTwo.animate(toDoubleValueA: Double((self.currentColor?.red)!))
                self.ringThree.animate(toDoubleValueB: Double((self.currentColor?.green)!))
                self.ringFour.animate(toDoubleValueC: Double((self.currentColor?.blue)!))
//

            } else {
////                // CMYK Mode
//                self.ringOne.doubleValue = Double((self.currentColor?.cyan)!)
//                self.ringTwo.doubleValue = Double((self.currentColor?.red)!)
//                self.ringThree.doubleValue = Double((self.currentColor?.yellow)!)
//                self.ringFour.doubleValue = Double((self.currentColor?.black)!)
                

                self.ringOne.animate(toDoubleValueA: Double((self.currentColor?.cyan)!))
                self.ringTwo.animate(toDoubleValueB: Double((self.currentColor?.magenta)!))
                self.ringThree.animate(toDoubleValueC: Double((self.currentColor?.yellow)!))
                self.ringFour.animate(toDoubleValueD: Double((self.currentColor?.black)!))
            }
            
            self.view.window?.backgroundColor = self.currentColor!.getNSColor()
            self.titleShadowBar.image = self.currentColor!.getTitleImage(width: Int(self.view.frame.width), height: 21)
            
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
