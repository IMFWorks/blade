//
//  PageInfo.swift
//  blade
//
//  Created by sangya on 2021/9/1.
//

import Foundation
public struct PageInfo {
    public var name: String = ""
    public var id: String = ""
    public var arguments: [String: Any] = [String: Any]()
    public init(name: String, id: String, params: [String: Any]){
        self.name = name
        self.id = id
        self.arguments = params
    }
    public init(){
    }
    
    var pDictionary: [String: Any] {
        return [
            "name": name,
            "id": id,
            "arguments": arguments,
        ]
    }
}
