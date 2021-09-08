//
//  PlatformCoordinator.swift
//  blade
//
//  Created by sangya on 2021/8/31.
//

import Foundation
class PlatformCoordinator {
    private var handlers = [String:((call:FlutterMethodCall,result:@escaping FlutterResult)->Void)]()
    init(channel:FlutterMethodChannel) {
        setHandlers()
        channel.setMethodCallHandler { (call, result) in
            self.handlers[call.method]?(call, result)
        }
    }
    
    func setHandlers(){
        handlers["popNativePage"] = {(call:FlutterMethodCall,result) in
            guard let arguments = call.arguments as? String else{return}
            Blade.shared.containerManager?.handlePopNativePageEvent(FlutterBaseEvent(json: arguments , result: result))
            result(true)
        }
        handlers["pushNativePage"] = {(call:FlutterMethodCall,result) in
            guard let arguments = call.arguments as? String else{return}
            Blade.shared.pushNativePage(event: FlutterBaseEvent(json: arguments , result: result))
        }
        handlers["pushFlutterPage"] = {(call:FlutterMethodCall,result) in
            guard let arguments = call.arguments as? String else{return}
            Blade.shared.pushFlutterPage(event: FlutterBaseEvent(json: arguments , result: result))
        }
    }
}
