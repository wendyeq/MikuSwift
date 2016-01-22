//
//  NSObject_Extension.swift
//
//  Created by wendyeq on 16/1/19.
//  Copyright © 2016年 wendyeq. All rights reserved.
//

import Foundation
import AppKit

extension NSObject {
    class func pluginDidLoad(bundle: NSBundle) {
        let appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? NSString
        if appName == "Xcode" {
        	if sharedPlugin == nil {
        		sharedPlugin = MikuSwift(bundle: bundle)
        	}
        }
    }
    
    func mikuViewDidLoad() {
        // hook不了
    }
    
    
    func mikuTextView(textView: NSTextView,
        shouldChangeTextInRange affectedCharRange: NSRange,
        replacementString: String?) -> Bool {
        let mikuDragView = MikuDragView.getSharedInstance()
        mikuDragView.mikuWebView!.setPlayingTime(10)
        // 不要问为什么这么多superview
        textView.superview!.superview!.superview!.addSubview(mikuDragView)
        return self.mikuTextView(textView, shouldChangeTextInRange: affectedCharRange, replacementString: replacementString)
    }

}