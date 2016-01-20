//
//  MikuDrag.swift
//  MikuSwift
//
//  Created by wendyeq on 16/1/17.
//  Copyright © 2016年 wendyeq. All rights reserved.
//

import Cocoa
import Foundation
import WebKit


class MikuDragView: WebView,WebFrameLoadDelegate {
    
    var lastLocation: NSPoint = NSPoint(x: 200, y: 200)
    var mikuWebView : MikuWebView?
    
    static let _mikuDragView = MikuDragView()
    
    class func getSharedInstance() -> MikuDragView {
        return _mikuDragView
    }
    
    override init!(frame: NSRect, frameName: String!, groupName: String!) {
        super.init(frame: frame, frameName: nil, groupName: nil)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: NSMakeRect(500, 50, 200, 300))
        self.hidden = false;
        self.drawsBackground = false
        
        mikuWebView = MikuWebView(frame: self.bounds)
        mikuWebView!.frameLoadDelegate = self
        self.addSubview(mikuWebView!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.lastLocation = (self.superview?.convertPoint(theEvent.locationInWindow, toView: nil))!
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        let newLocation = self.superview?.convertPoint(theEvent.locationInWindow, toView: nil)
        var origin = self.frame.origin
        origin.x += (newLocation!.x - self.lastLocation.x)
        origin.y += (newLocation!.y - self.lastLocation.y)
        self.setFrameOrigin(origin)
        self.lastLocation = newLocation!
    }
    
    func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        self.mikuWebView?.setPlayingTime(10)
        self.mikuWebView?.setIsKeepDancing(true)
        self.mikuWebView?.setMusicType(MusicType.Normal)
        
    }
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    
}

