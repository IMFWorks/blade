//
//  FlutterChannel.swift
//  blade
//
//  Created by sangya on 2021/8/31.
//

import Foundation
class FlutterChannel {
    let channel :FlutterMethodChannel
    init(messager:FlutterBinaryMessenger, channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func sendEvent(event: NativeBaseEvent){
        self.channel.invokeMethod(event.methodName, arguments: event.toJson) { (result) in
            print(result)
        }
    }
}
