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
        
        paletteMenu.addItem(withTitle: "地铁标志色", action: #selector(switchToMetroColors(_:)), keyEquivalent: "m")
        paletteMenu.addItem(withTitle: "中国色", action: #selector(switchToChineseColors(_:)), keyEquivalent: "c")
        paletteMenu.addItem(withTitle: "日本の伝統色", action: #selector(switchToNipponColors(_:)), keyEquivalent: "n")
        
        moreMenu.title = "更多选项"
        moreMenu.addItem(withTitle: "改用 CMYK 表示", action: #selector(switchColorDisplay(_:)), keyEquivalent: "s")
        moreMenu.addItem(withTitle: "选择调色板", action: #selector(releaseUI(_:)), keyEquivalent: "")
        moreMenu.setSubmenu(paletteMenu, for: moreMenu.item(withTitle: "选择调色板")!)
        moreMenu.addItem(NSMenuItem.separator())
        moreMenu.addItem(withTitle: "RGB Displayer", action: nil, keyEquivalent: "")
        moreMenu.addItem(withTitle: "CMYK Displayer", action: nil, keyEquivalent: "")
        moreMenu.addItem(withTitle: "HSL Displayer", action: nil, keyEquivalent: "")
        moreMenu.addItem(withTitle: "拷贝十六进制颜色表示", action: #selector(copyHexStr(_:)), keyEquivalent: "o")
        moreMenu.addItem(NSMenuItem.separator())
        moreMenu.addItem(withTitle: "致谢", action: #selector(showAcknowledgements(_:)), keyEquivalent: "a")
        moreButton.menu = moreMenu
        
        moreMenu.item(at: 2)?.isEnabled = false
        moreMenu.item(at: 3)?.isEnabled = false
        moreMenu.item(at: 4)?.isEnabled = false
        
        setFont()
        
        loadPalette()
        
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
    
    @objc func showAcknowledgements(_ sender: NSMenuItem) {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Acknowledgements Controller")) as! NSWindowController
        
        if let window = windowController.window {
            self.view.window?.beginSheet(window, completionHandler: nil)
        }
        self.isNextTap = false
    }
    
    @objc func copyHexStr(_ sender: NSMenuItem) {
        let hexVal = self.currentColor?.getHexString()
        if hexVal != nil {
            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
            pasteboard.setString(hexVal!, forType: NSPasteboard.PasteboardType.string)
        }
        self.isNextTap = false
    }
    
    func loadPalette() {
        
        let chinese = loadResources(Palette.chineseColors)
        let nippon = loadResources(Palette.nipponColors)
        let metro = loadResources(Palette.metroColors)
        
        palettes[Palette.chineseColors.rawValue] = chinese
        palettes[Palette.nipponColors.rawValue] = nippon
        palettes[Palette.metroColors.rawValue] = metro
        
        switchPalette(Palette.chineseColors)
        
        switchToChineseColors(NSMenuItem())
        switchColorDisplay(NSMenuItem())
        
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
            isNextTap = false
            return
        }
        
        switchPalette(.chineseColors)
        isNextTap = false
        
        paletteMenu.item(withTitle: "中国色")!.state = .on
        paletteMenu.item(withTitle: "日本の伝統色")!.state = .off
        paletteMenu.item(withTitle: "地铁标志色")!.state = .off
    }
    
    @objc func switchToNipponColors(_ sender: NSMenuItem) {
        if paletteMenu.item(withTitle: "日本の伝統色")!.state == .on {
            isNextTap = false
            return
        }
        switchPalette(.nipponColors)
        isNextTap = false
        
        paletteMenu.item(withTitle: "中国色")!.state = .off
        paletteMenu.item(withTitle: "日本の伝統色")!.state = .on
        paletteMenu.item(withTitle: "地铁标志色")!.state = .off
    }
    
    @objc func switchToMetroColors(_ sender: NSMenuItem) {
        if paletteMenu.item(withTitle: "地铁标志色")!.state == .on {
            isNextTap = false
            return
        }
        switchPalette(.metroColors)
        isNextTap = false
        
        paletteMenu.item(withTitle: "中国色")!.state = .off
        paletteMenu.item(withTitle: "日本の伝統色")!.state = .off
        paletteMenu.item(withTitle: "地铁标志色")!.state = .on
    }
    
    @objc func switchColorDisplay(_ sender: NSMenuItem) {
        
        isRGBAndNotCMYK = !isRGBAndNotCMYK
        if isRGBAndNotCMYK {
            ringOne.isHidden = true
            ringTwo.maxValue = 255
            ringThree.maxValue = 255
            ringFour.maxValue = 255
            
            ringTwo.doubleValue *= 2.55
            ringThree.doubleValue *= 2.55
            ringFour.doubleValue *= 2.55
            
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
            
            ringOne.doubleValue = 0.0
            ringTwo.doubleValue *= 0.392
            ringThree.doubleValue *= 0.392
            ringFour.doubleValue *= 0.392
            
            moreMenu.item(withTitle: "改用 CMYK 表示")?.title = "改用 RGB 表示"
            
            CLabel.isHidden = false
            MLabel.isHidden = false
            YLabel.isHidden = false
            KLabel.isHidden = false
            RLabel.isHidden = true
            GLabel.isHidden = true
            BLabel.isHidden = true
        }
        setColorDisplay()
        self.isNextTap = false
    }
    
    func setFont() {
        self.mainNameTitle.font = getFont(.mainName)
        self.aliasNameTitle.font = getFont(.aliasName)
    }
    
    func setColorDisplay() {
        if self.currentColor != nil {
            
            let textColor: NSColor = self.currentColor!.getTextColor()
            self.mainNameTitle.stringValue = self.currentColor!.name ?? "__COLOR_NAME__"
            self.mainNameTitle.textColor = textColor
            
            self.aliasNameTitle.stringValue = fixSpelling(self.currentColor!.aliasName)
            self.aliasNameTitle.textColor = textColor
            
            self.RLabel.textColor = textColor
            self.GLabel.textColor = textColor
            self.BLabel.textColor = textColor
            self.CLabel.textColor = textColor
            self.MLabel.textColor = textColor
            self.YLabel.textColor = textColor
            self.KLabel.textColor = textColor
            
            self.moreMenu.item(at: 3)?.title = (self.currentColor?.getRGBString())!
            self.moreMenu.item(at: 4)?.title = (self.currentColor?.getCMYKString())!
            self.moreMenu.item(at: 5)?.title = (self.currentColor?.getHSLString())!
            self.moreMenu.item(at: 6)?.title = "拷贝十六进制表示： \(self.currentColor?.getHexString() ?? "未知")"
            
            if #available(OSX 10.14, *) {
                if self.currentColor!.shouldShowDark() {
                    self.ringOne.appearance = NSAppearance(named: .darkAqua)
                    self.ringTwo.appearance = NSAppearance(named: .darkAqua)
                    self.ringThree.appearance = NSAppearance(named: .darkAqua)
                    self.ringFour.appearance = NSAppearance(named: .darkAqua)
                } else {
                    self.ringOne.appearance = NSAppearance(named: .aqua)
                    self.ringTwo.appearance = NSAppearance(named: .aqua)
                    self.ringThree.appearance = NSAppearance(named: .aqua)
                    self.ringFour.appearance = NSAppearance(named: .aqua)
                }
            }
            
            if isRGBAndNotCMYK {
                // RGB Mode
//                self.ringTwo.doubleValue = Double((self.currentColor?.red)!)
//                self.ringThree.doubleValue = Double((self.currentColor?.green)!)
//                self.ringFour.doubleValue = Double((self.currentColor?.blue)!)
                
                
                self.ringTwo.animate(toDoubleValueA: Double((self.currentColor?.red)!))
                self.ringThree.animate(toDoubleValueB: Double((self.currentColor?.green)!))
                self.ringFour.animate(toDoubleValueC: Double((self.currentColor?.blue)!))
//
                self.ringOne.toolTip = ""
                self.ringTwo.toolTip = "R: \(self.currentColor?.red ?? -1)"
                self.ringThree.toolTip = "G: \(self.currentColor?.green ?? -1)"
                self.ringFour.toolTip = "B: \(self.currentColor?.blue ?? -1)"

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
                
                self.ringOne.toolTip = "C: \(self.currentColor?.cyan ?? -1)"
                self.ringTwo.toolTip = "M: \(self.currentColor?.magenta ?? -1)"
                self.ringThree.toolTip = "Y: \(self.currentColor?.yellow ?? -1)"
                self.ringFour.toolTip = "K: \(self.currentColor?.black ?? -1)"
            }
            
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
