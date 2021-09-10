//
//  FlutterBaseEvent.swift
//  blade
//
//  Created by sangya on 2021/9/7.
//

import Foundation
public struct FlutterBaseEvent {
    public var payload: PageInfo?
    public var result:FlutterResult?
    init(json:String,result:@escaping FlutterResult) {
        self.result = result
        do{
            guard let dic = try JSONSerialization.jsonObject(with: json.data(using: .utf8) ?? Data(), options: .mutableContainers) as? [String : Any] else {
                return
            }
            guard let id = dic["id"] as? String, let name = dic["name"] as? String,let arguments = dic["arguments"] as? [String: Any] else {
                return
            }
            self.payload = PageInfo(name: name, id: id, params: arguments)
        }catch{
            print(error)
        }
    }
}
