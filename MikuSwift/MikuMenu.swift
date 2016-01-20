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
        
        let mikuMenu = NSMenu()
        mikuMenu.autoenablesItems = false
        
        self.title = "MikuSwifit"
        self.submenu = mikuMenu
        
        enablePluginMenuItem = NSMenuItem(title: "Enable", action: "clickMenuItem:", keyEquivalent:"M")
        enablePluginMenuItem!.target = self
        enablePluginMenuItem!.state = 0
        enablePluginMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnablePlugin.rawValue
        enablePluginMenuItem!.keyEquivalentModifierMask = Int(NSEventModifierFlags.ControlKeyMask.rawValue)
        mikuMenu.addItem(enablePluginMenuItem!)
        
        dancingMenuItem = NSMenuItem(title: "Enable keep Dancing", action: "clickMenuItem:", keyEquivalent: "")
        dancingMenuItem!.target = self
        dancingMenuItem!.state = 1
        dancingMenuItem!.enabled = false
        dancingMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnableKeepDancing.rawValue
        mikuMenu.addItem(dancingMenuItem!)
        
        
        // music
        let musicMenu = NSMenu()
        musicMenu.autoenablesItems = false
        
        musicTypeMeneItem = NSMenuItem(title:"Music Type", action:"clickMenuItem:", keyEquivalent:"")
        musicTypeMeneItem!.target = self
        musicTypeMeneItem!.submenu = musicMenu
        musicTypeMeneItem!.enabled = false
        self.submenu?.addItem(musicTypeMeneItem!)
        
        musicDefaultMenuItem = NSMenuItem(title: "Default  🔈", action:"clickMenuItem:", keyEquivalent:"")
        musicDefaultMenuItem!.target = self
        musicDefaultMenuItem!.state = 0
        musicDefaultMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnableMusicDefault.rawValue
        musicMenu.addItem(musicDefaultMenuItem!)
        
        musicNormalMenuItem = NSMenuItem(title: "Normal  🔊", action:"clickMenuItem:", keyEquivalent:"")
        musicNormalMenuItem!.target = self
        musicNormalMenuItem!.state = 1
        musicNormalMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnableMusicNormal.rawValue
        musicMenu.addItem(musicNormalMenuItem!)
        
        musicMuteMenuItem = NSMenuItem(title: "Mute      🔇", action:"clickMenuItem:", keyEquivalent:"")
        musicMuteMenuItem!.target = self
        musicMuteMenuItem!.state = 0
        musicMuteMenuItem!.tag = MenuItemType.MikuMenuItemTypeEnableMusicMute.rawValue
        musicMenu.addItem(musicMuteMenuItem!)
    }

    func clickMenuItem(menuItem: NSMenuItem) {
        MikuHook().hook()
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
                        mikuDargView.hidden = true
                        mikuWebView?.pause()
                        self.dancingMenuItem?.enabled = false
                        self.musicTypeMeneItem?.enabled = false
                    }else {
                        mikuDargView.hidden = false
                        mikuWebView?.play()
                        self.dancingMenuItem?.enabled = true
                        self.musicTypeMeneItem?.enabled = true
                    }
                case .MikuMenuItemTypeEnableKeepDancing:
                    mikuWebView?.setIsKeepDancing(true)
                case .MikuMenuItemTypeEnableMusicDefault:
                    mikuWebView?.setMusicType(MusicType.Default)
                    musicNormalMenuItem?.state = 0
                    musicMuteMenuItem?.state = 0
                case .MikuMenuItemTypeEnableMusicNormal:
                    mikuWebView?.setMusicType(MusicType.Normal)
                    musicDefaultMenuItem?.state = 0
                    musicMuteMenuItem?.state = 0
                case .MikuMenuItemTypeEnableMusicMute:
                    mikuWebView?.setMusicType(MusicType.Mute)
                    musicDefaultMenuItem?.state = 0
                    musicNormalMenuItem?.state = 0
            }
        }
    }

}

enum MenuItemType: Int {
    case MikuMenuItemTypeEnablePlugin = 1
    case MikuMenuItemTypeEnableKeepDancing
    case MikuMenuItemTypeEnableMusicDefault
    case MikuMenuItemTypeEnableMusicNormal
    case MikuMenuItemTypeEnableMusicMute
}