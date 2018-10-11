//
//  MainViewController.swift
//  cai-yun
//
//  Created by yuxiqian on 2018/9/30.
//  Copyright © 2018 yuxiqian. All rights reserved.
//

import Cocoa
import YapAnimator

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
        
        self.titleShadowBar.wantsLayer = true
        
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
    
    override func viewDidAppear() {
        if currentColor != nil {
            setColorDisplay()
        }
        self.imageWrapper.backgroundColor = self.currentColor?.getNSColor()
    }
    
    override func viewWillLayout() {

        
        self.titleShadowBar.layer?.backgroundColor = self.currentColor!.getTitleBarColor()

        
        updateConstraints()
        
        
    }
    
    
    @IBOutlet weak var titleShadowBar: NSImageView!
    @IBOutlet weak var mainNameTitle: NSTextField!
    @IBOutlet weak var aliasNameTitle: NSTextField!
    
    @IBOutlet weak var ringOne: NSProgressIndicator!
    @IBOutlet weak var ringTwo: NSProgressIndicator!
    @IBOutlet weak var ringThree: NSProgressIndicator!
    @IBOutlet weak var ringFour: NSProgressIndicator!
    
    @IBOutlet weak var imageWrapper: NSTextField!
    
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
    
    @IBAction func aboutButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("About Window Controller")) as! NSWindowController
        
        if let window = windowController.window {
            self.view.window?.beginSheet(window, completionHandler: nil)
        }
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
//            ringOne.isHidden = true
            
            var targetPoint = ringFour.frame.origin
            
            RLabel.animated?.position.instant(to: ringFour.frame.origin.addOffset(.Yonly))
            GLabel.animated?.position.instant(to: ringFour.frame.origin.addOffset(.bothXandY))
            BLabel.animated?.position.instant(to: ringFour.frame.origin.addOffset(.Yonly))
            
            ringOne.animated?.position.animate(to: ringFour.frame.origin)
            ringOne.animated?.opacity.animate(to: 0.0)
            
            targetPoint.y += 80
            
            RLabel.animated?.position.animate(to: targetPoint.addOffset(.Yonly))
            RLabel.animated?.opacity.animate(to: 1.0)
            
            targetPoint.y -= 40
            
            GLabel.animated?.position.animate(to: targetPoint.addOffset(.bothXandY))
            GLabel.animated?.opacity.animate(to: 1.0)
            
            targetPoint.y -= 40
            
            BLabel.animated?.position.animate(to: targetPoint.addOffset(.Yonly))
            BLabel.animated?.opacity.animate(to: 1.0)
            
            
            ringTwo.maxValue = 255.0
            ringThree.maxValue = 255.0
            ringFour.maxValue = 255.0
            
            ringTwo.doubleValue = floor(ringTwo.doubleValue * 2.55)
            ringThree.doubleValue = floor(ringThree.doubleValue * 2.55)
            ringFour.doubleValue = floor(ringFour.doubleValue * 2.55)
            
            
            
            moreMenu.item(withTitle: "改用 RGB 表示")?.title = "改用 CMYK 表示"
            
            CLabel.animated?.position.animate(to: ringFour.frame.origin.addOffset(.bothXandY))
            CLabel.animated?.opacity.animate(to: 0.0)
            
            
            MLabel.animated?.position.animate(to: ringFour.frame.origin.addOffset(.Yonly))
            MLabel.animated?.opacity.animate(to: 0.0)
            
            
            YLabel.animated?.position.animate(to: ringFour.frame.origin.addOffset(.bothXandY))
            YLabel.animated?.opacity.animate(to: 0.0)
            
            
            KLabel.animated?.position.animate(to: ringFour.frame.origin.addOffset(.bothXandY))
            KLabel.animated?.opacity.animate(to: 0.0)
            
            
        } else {
            
            var targetPoint = ringFour.frame.origin
            
            targetPoint.y += 120
            
            ringOne.animated?.position.instant(to: ringFour.frame.origin)
            
            CLabel.animated?.position.instant(to: ringFour.frame.origin.addOffset(.bothXandY))
            MLabel.animated?.position.instant(to: ringFour.frame.origin.addOffset(.Yonly))
            YLabel.animated?.position.instant(to: ringFour.frame.origin.addOffset(.bothXandY))
            KLabel.animated?.position.instant(to: ringFour.frame.origin.addOffset(.bothXandY))
            
            
            ringOne.animated?.position.animate(to: targetPoint)
            ringOne.animated?.opacity.animate(to: 1.0)
            
            CLabel.animated?.position.animate(to: targetPoint.addOffset(.bothXandY))
            CLabel.animated?.opacity.animate(to: 1.0)
            
            targetPoint.y -= 40
            
            MLabel.animated?.position.animate(to: targetPoint.addOffset(.Yonly))
            MLabel.animated?.opacity.animate(to: 1.0)
            
            targetPoint.y -= 40
            
            YLabel.animated?.position.animate(to: targetPoint.addOffset(.bothXandY))
            YLabel.animated?.opacity.animate(to: 1.0)
            
            targetPoint.y -= 40
            
            KLabel.animated?.position.animate(to: targetPoint.addOffset(.bothXandY))
            KLabel.animated?.opacity.animate(to: 1.0)
            
            RLabel.animated?.position.animate(to: ringFour.frame.origin.addOffset(.Yonly))
            RLabel.animated?.opacity.animate(to: 0.0)
            
            
            GLabel.animated?.position.animate(to: ringFour.frame.origin.addOffset(.bothXandY))
            GLabel.animated?.opacity.animate(to: 0.0)
            
            
            BLabel.animated?.position.animate(to: ringFour.frame.origin.addOffset(.Yonly))
            BLabel.animated?.opacity.animate(to: 0.0)
            
            ringTwo.minValue = 0.0
            ringThree.minValue = 0.0
            ringFour.minValue = 0.0
            

            
            ringOne.doubleValue = 0.0
            ringTwo.doubleValue = floor(ringTwo.doubleValue * 0.392)
            ringThree.doubleValue = floor(ringThree.doubleValue * 0.392)
            ringFour.doubleValue = floor(ringFour.doubleValue * 0.392)
            
            ringTwo.maxValue = 100.0
            ringThree.maxValue = 100.0
            ringFour.maxValue = 100.0
            
            moreMenu.item(withTitle: "改用 CMYK 表示")?.title = "改用 RGB 表示"
            

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
            
            if self.mainNameTitle.animated != nil {
                self.mainNameTitle.animated?.opacity.animate(to: 0.0) {_,_ in
                    self.mainNameTitle.stringValue = self.currentColor!.name ?? ""
                    self.mainNameTitle.textColor = textColor
                    self.mainNameTitle.animated?.opacity.animate(to: 1.0)
                }
            } else {
                self.mainNameTitle.stringValue = self.currentColor!.name ?? ""
                self.mainNameTitle.textColor = textColor
            }
            
            if self.aliasNameTitle.animated != nil {
                self.aliasNameTitle.animated?.opacity.animate(to: 0.0) {_,_ in
                    self.aliasNameTitle.stringValue = fixSpelling(self.currentColor!.aliasName)
                    self.aliasNameTitle.textColor = textColor
                    self.aliasNameTitle.animated?.opacity.animate(to: 1.0)
                }
            } else {
                self.aliasNameTitle.stringValue = fixSpelling(self.currentColor!.aliasName)
                self.aliasNameTitle.textColor = textColor
            }
            
            
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
                
                
                self.ringTwo.animate(toDoubleValueB: Double((self.currentColor?.red)!))
                self.ringThree.animate(toDoubleValueC: Double((self.currentColor?.green)!))
                self.ringFour.animate(toDoubleValueD: Double((self.currentColor?.blue)!))
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
            
            self.imageWrapper.animated?.opacity.instant(to: 1.0)
            self.imageWrapper.backgroundColor = self.view.window?.backgroundColor
            
            self.view.window?.backgroundColor = self.currentColor!.getNSColor()
            
            self.imageWrapper.animated?.opacity.animate(to: 0.0)

            
//
            
//            self.titleShadowBar.animated?.backgroundColor.animate(to: self.currentColor!.getAccentColor())
//
            self.titleShadowBar.layer?.backgroundColor = self.currentColor!.getTitleBarColor()
//            self.titleShadowBar.image = self.currentColor!.getTitleImage(width: Int(self.view.frame.width), height: 20)
            
        }
    }
    
    func updateConstraints() {
        
        CLabel.animated?.position.instant(to: ringOne.frame.origin.addOffset(.bothXandY))
        MLabel.animated?.position.instant(to: ringTwo.frame.origin.addOffset(.Yonly))
        YLabel.animated?.position.instant(to: ringThree.frame.origin.addOffset(.bothXandY))
        KLabel.animated?.position.instant(to: ringFour.frame.origin.addOffset(.bothXandY))
        
        RLabel.animated?.position.instant(to: ringTwo.frame.origin.addOffset(.Yonly))
        GLabel.animated?.position.instant(to: ringThree.frame.origin.addOffset(.bothXandY))
        BLabel.animated?.position.instant(to: ringFour.frame.origin.addOffset(.Yonly))
        
        if isRGBAndNotCMYK {
            ringOne.animated?.position.instant(to: ringFour.frame.origin)
        } else {
            var ringOnePoint = ringFour.frame.origin
            ringOnePoint.y += 120
            ringOne.animated?.position.instant(to: ringOnePoint)
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
