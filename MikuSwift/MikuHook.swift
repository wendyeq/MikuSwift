//
//  IDEHook.swift
//  MikuSwift
//
//  Created by wendyeq on 16/1/18.
//  Copyright © 2016年 wendyeq. All rights reserved.
//

import Foundation
import AppKit

class MikuHook {
    
    func hook() {
        guard let srcEditorClass = NSClassFromString("IDESourceCodeEditor") as? NSObject.Type else {
            return
        }
        
        do {
            try srcEditorClass.jr_swizzleMethod("viewDidLoad", withMethod: "mikuViewDidLoad")
            try srcEditorClass.jr_swizzleMethod("textView:shouldChangeTextInRange:replacementString:", withMethod: "mikuTextView:shouldChangeTextInRange:replacementString:")
        }
        catch {
            print(error)
            Swift.print("Swizzling failed")
        }
        
    }
    
}
