//
//  MikuConfig.swift
//  MikuSwift
//
//  Created by wendyeq on 16/1/22.
//  Copyright © 2016年 wendyeq. All rights reserved.
//

import Foundation

class MikuConfig {
    var enablePlugin = false
    var enableKeepDancing = true
    var musicType = 0
    
    static let _mikuConfig = MikuConfig()
    
    class func getSharedInstance() -> MikuConfig{
        return _mikuConfig
    }
    
    private init() {
        
    }
    func isEnablePlugin() -> Bool{
        let enable = NSUserDefaults.standardUserDefaults().valueForKey(MikuConfigKey.MikuConfigEnablePlugin.rawValue) as? Bool
        if enable == nil {
            setBool(false, forKey: MikuConfigKey.MikuConfigEnablePlugin.rawValue)
            setBool(true, forKey: MikuConfigKey.MikuConfigEnableKeepDancing.rawValue)
            setMusicType(MusicType.Normal.rawValue)
        }
        enablePlugin = boolForKey(MikuConfigKey.MikuConfigEnablePlugin.rawValue)
        return enablePlugin
    }
    
    func isEnableKeepDancing() -> Bool {
        enableKeepDancing = boolForKey(MikuConfigKey.MikuConfigEnableKeepDancing.rawValue)
        return enableKeepDancing
    }
    
    func getMusicType() -> Int {
        musicType = intForKey(MikuConfigKey.MikuConfigMusicType.rawValue)
        return musicType
    }
    
    func boolForKey(key: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    
    func setBool(value: Bool, forKey: String){
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: forKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func intForKey(key: String) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
    func setMusicType(musicType: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(musicType, forKey: MikuConfigKey.MikuConfigMusicType.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}

enum MikuConfigKey: String {
    case MikuConfigEnablePlugin = "MikuConfigEnablePlugin"
    case MikuConfigEnableKeepDancing = "MikuConfigEnableKeepDancing"
    case MikuConfigMusicType = "MikuConfigMusicType"
}