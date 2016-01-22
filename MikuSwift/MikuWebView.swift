//
//  MikuWebView.swift
//  MikuSwift
//
//  Created by wendyeq on 16/1/17.
//  Copyright © 2016年 wendyeq. All rights reserved.
//

import WebKit
import Foundation
import AppKit

enum MusicType: Int {
    case Default = 0 //默认模式，慢动作时音乐播放会变慢
    case Normal    //正常模式，慢动作时音乐播放不变慢
    case Mute      //静音模式
}

class MikuWebView: WebView{
    override init!(frame: NSRect, frameName: String!, groupName: String!) {
        super.init(frame: frame, frameName: nil, groupName: nil)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.drawsBackground = false;
        
        
        let pluginPath = "~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/MikuSwift.xcplugin"
        let pluginBundle = NSBundle(path: pluginPath)
        let htmlPath = pluginBundle?.pathForResource("index", ofType: "html",inDirectory: "miku-dancing.coding.io")
        let htmlUrl = NSURL(fileURLWithPath: htmlPath!)
        let request = NSURLRequest(URL: htmlUrl)
        self.mainFrame.loadRequest(request)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(aPoint: NSPoint) -> NSView? {
        return self.nextResponder as? NSView
    }
    
    func play() {
        self.stringByEvaluatingJavaScriptFromString("control.play()")
    }
    
    func pause() {
        self.stringByEvaluatingJavaScriptFromString("control.pause()")
    }
    
    // 设置播放时间
    func setPlayingTime(seconds: Int) {
         self.stringByEvaluatingJavaScriptFromString("control.addFrame(\(seconds))")
    }
    
    func setIsKeepDancing(isKeepDancing: Bool) {
        self.stringByEvaluatingJavaScriptFromString("control.dance(\(isKeepDancing))")
    }
    
    func setMusicType(musicType: MusicType) {
        switch musicType {
            case .Default:
                self.stringByEvaluatingJavaScriptFromString("control.mute(false)")
                self.stringByEvaluatingJavaScriptFromString("control.music(false)")
            case .Normal:
                self.stringByEvaluatingJavaScriptFromString("control.mute(false)")
                self.stringByEvaluatingJavaScriptFromString("control.music(true)")
            case .Mute:
                self.stringByEvaluatingJavaScriptFromString("control.mute(true)")
        }
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        let pasteboard = sender.draggingPasteboard()
        if ((pasteboard.types?.contains(NSFilenamesPboardType)) != nil) {
            return NSDragOperation.Copy
        }
        return NSDragOperation.None
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard()
        let list = pasteboard.propertyListForType(NSFilenamesPboardType)
        let fileURL = list?.firstObject
        let script = "control.setPlayList(\(fileURL))"
        self.stringByEvaluatingJavaScriptFromString(script)
        return false
    }
    
    
}
