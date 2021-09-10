//
//  FlutterEvent.swift
//  blade
//
//  Created by sangya on 2021/9/1.
//

import Foundation

protocol NativeBaseEvent {
    var methodName:String {get set}
    var pageInfo:PageInfo? {get set}
    var toJson: String{get}
}

extension NativeBaseEvent {
    var toJson: String {
        guard let info = pageInfo, let jsonData = try? JSONSerialization.data(withJSONObject: info.pDictionary, options: .prettyPrinted) else {
            return "toJson error"
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return "toJson error"
        }
        return jsonString
    }
}
