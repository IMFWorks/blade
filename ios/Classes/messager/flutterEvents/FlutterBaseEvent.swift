//
//  FlutterBaseEvent.swift
//  blade
//
//  Created by sangya on 2021/9/7.
//

import Foundation
public class FlutterBaseEvent {
    public var payload: PageInfo?
    public var result:FlutterResult?
    init(json:String,result:@escaping FlutterResult) {
        self.result = result
        do{
            self.payload = try JSONDecoder().decode(PageInfo.self, from: json.data(using: .utf8) ?? Data())
        }catch{
            print(error)
        }
    }
}
