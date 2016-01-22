//
//  MikuMenu.swift
//  MikuSwift
//
//  Created by wendyeq on 16/1/21.
//  Copyright © 2016年 wendyeq. All rights reserved.
//

import Foundation

class MikuMenu: NSMenuItem {
    var enablePluginMenuItem: NSMenuItem?
    var dancingMenuItem: NSMenuItem?
    var musicTypeMeneItem: NSMenuItem?
    var musicDefaultMenuItem: NSMenuItem?
    var musicNormalMenuItem: NSMenuItem?
    var musicMuteMenuItem: NSMenuItem?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(title aString: String, action aSelector: Selector, keyEquivalent charCode: String) {
        super.init(title: aString, action: aSelector, keyEquivalent: charCode)
    }
    override init() {
        super.init()
        let mikuConfig = MikuConfig.getSharedInstance()
        
        let mikuMenu = NSMenu()
        mikuMenu.autoenablesItems = false
        
        self.title = "MikuSwifit"
        self.submenu = mikuMenu
        
        enablePluginMenuItem = NSMenuItem(title: "Enable", action: "clickMenuItem:", keyEquivalent:"M")
        enablePluginMenuItem!.target = self
        enablePluginMenuItem!.state = bool2Int(mikuConfig.isEnablePlugin())
        enablePluginMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnablePlugin.rawValue
        enablePluginMenuItem!.keyEquivalentModifierMask = Int(NSEventModifierFlags.ControlKeyMask.rawValue)
        mikuMenu.addItem(enablePluginMenuItem!)
        
        dancingMenuItem = NSMenuItem(title: "Enable keep Dancing", action: "clickMenuItem:", keyEquivalent: "")
        dancingMenuItem!.target = self
        dancingMenuItem!.state = bool2Int(mikuConfig.isEnableKeepDancing())
        dancingMenuItem!.enabled = mikuConfig.isEnablePlugin()
        dancingMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnableKeepDancing.rawValue
        mikuMenu.addItem(dancingMenuItem!)
        
        
        // music
        let musicMenu = NSMenu()
        musicMenu.autoenablesItems = false
        
        musicTypeMeneItem = NSMenuItem(title:"Music Type", action:"clickMenuItem:", keyEquivalent:"")
        musicTypeMeneItem!.target = self
        musicTypeMeneItem!.submenu = musicMenu
        musicTypeMeneItem!.enabled = mikuConfig.isEnablePlugin()
        self.submenu?.addItem(musicTypeMeneItem!)
        
        musicDefaultMenuItem = NSMenuItem(title: "Default  🔈", action:"clickMenuItem:", keyEquivalent:"")
        musicDefaultMenuItem!.target = self
        musicDefaultMenuItem!.state = musicType2Int(MusicType.Default)
        musicDefaultMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnableMusicDefault.rawValue
        musicMenu.addItem(musicDefaultMenuItem!)
        
        musicNormalMenuItem = NSMenuItem(title: "Normal  🔊", action:"clickMenuItem:", keyEquivalent:"")
        musicNormalMenuItem!.target = self
        musicNormalMenuItem!.state = musicType2Int(MusicType.Normal)
        musicNormalMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnableMusicNormal.rawValue
        musicMenu.addItem(musicNormalMenuItem!)
        
        musicMuteMenuItem = NSMenuItem(title: "Mute      🔇", action:"clickMenuItem:", keyEquivalent:"")
        musicMuteMenuItem!.target = self
        musicMuteMenuItem!.state = musicType2Int(MusicType.Mute)
        musicMuteMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnableMusicMute.rawValue
        musicMenu.addItem(musicMuteMenuItem!)
    }
    
    func clickMenuItem(menuItem: NSMenuItem) {
        
        let mikuConfig = MikuConfig.getSharedInstance()
        
        if menuItem.state == 0 {
            menuItem.state = 1
        }else {
            menuItem.state = 0
        }
        let mikuDargView = MikuDragView.getSharedInstance()
        let mikuWebView = mikuDargView.mikuWebView
        if let type = MenuItemType(rawValue: menuItem.tag) {
            switch type {
            case .MikuMenuItemTypeEnablePlugin:
                if menuItem.state == 0 {
                    mikuConfig.setBool(false, forKey: MikuConfigKey.MikuConfigEnablePlugin.rawValue)
                    mikuDargView.hidden = true
                    mikuWebView?.pause()
                    self.dancingMenuItem?.enabled = false
                    self.musicTypeMeneItem?.enabled = false
                }else {
                    MikuHook().hook()
                    mikuConfig.setBool(true, forKey: MikuConfigKey.MikuConfigEnablePlugin.rawValue)
                    mikuDargView.hidden = false
                    mikuWebView?.play()
                    self.dancingMenuItem?.enabled = true
                    self.musicTypeMeneItem?.enabled = true
                }
            case .MikuMenuItemTypeEnableKeepDancing:
                mikuConfig.setBool(!mikuConfig.isEnableKeepDancing(), forKey: MikuConfigKey.MikuConfigEnableKeepDancing.rawValue)
                mikuWebView?.setIsKeepDancing(mikuConfig.isEnableKeepDancing())
            case .MikuMenuItemTypeEnableMusicDefault:
                mikuConfig.setMusicType(MusicType.Default.rawValue)
                mikuWebView?.setMusicType(MusicType.Default)
                musicNormalMenuItem?.state = 0
                musicMuteMenuItem?.state = 0
            case .MikuMenuItemTypeEnableMusicNormal:
                mikuConfig.setMusicType(MusicType.Normal.rawValue)
                mikuWebView?.setMusicType(MusicType.Normal)
                musicDefaultMenuItem?.state = 0
                musicMuteMenuItem?.state = 0
            case .MikuMenuItemTypeEnableMusicMute:
                mikuConfig.setMusicType(MusicType.Mute.rawValue)
                mikuWebView?.setMusicType(MusicType.Mute)
                musicDefaultMenuItem?.state = 0
                musicNormalMenuItem?.state = 0
            }
        }
    }
    
    func bool2Int(value: Bool) -> Int {
        if value {
            return 1
        }
        return 0
    }
    
    func musicType2Int(musicType: MusicType) ->Int {
        let mikuConfig = MikuConfig.getSharedInstance()
        if musicType.rawValue == mikuConfig.getMusicType() {
            return 1
        }
        return 0
    }
    
}

enum MenuItemType: Int {
    case MikuMenuItemTypeEnablePlugin = 1
    case MikuMenuItemTypeEnableKeepDancing
    case MikuMenuItemTypeEnableMusicDefault
    case MikuMenuItemTypeEnableMusicNormal
    case MikuMenuItemTypeEnableMusicMute
}