//
//  MikuSwift.swift
//
//  Created by wendyeq on 16/1/19.
//  Copyright © 2016年 wendyeq. All rights reserved.
//

import AppKit

var sharedPlugin: MikuSwift?

class MikuSwift: NSObject {

    var bundle: NSBundle
    lazy var center = NSNotificationCenter.defaultCenter()

    init(bundle: NSBundle) {
        self.bundle = bundle
        super.init()
        center.addObserver(self, selector: Selector("createMenuItems"), name: NSApplicationDidFinishLaunchingNotification, object: nil)
        
    }

    deinit {
        removeObserver()
    }

    func removeObserver() {
        center.removeObserver(self)
    }

    func createMenuItems() {
        removeObserver()
        // 获取Plugins菜单，没有的话就在Window的左边加一个
        var menuItem = NSApp.mainMenu!.itemWithTitle("Plugins")
        if menuItem == nil {
            menuItem = NSMenuItem()
            menuItem!.title = "Plugins"
            menuItem!.submenu = NSMenu(title: "Plugins")
            let indx = NSApp.mainMenu!.indexOfItemWithTitle("Window")
            NSApp.mainMenu!.insertItem(menuItem!, atIndex: indx)
        }
        // 添加菜单项
        if menuItem != nil {
            menuItem?.submenu?.addItem(MikuMenu())
            
        }
    }
    
}


