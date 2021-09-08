//
//  FlutterEvent.swift
//  blade
//
//  Created by sangya on 2021/9/1.
//

import Foundation
public class NativeBaseEvent {
    public var methodName:String = ""
    public var pageInfo:PageInfo?
    var toJson:String {
        if let payload = pageInfo {
            do {
                let jsonBody = try JSONEncoder().encode(payload)
                return String.init(data: jsonBody, encoding: .utf8) ?? ""
            } catch {
                return "json error"
            }
        }else{
            return "payload nil"
        }
    }
}

