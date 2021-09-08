//
//  PageInfo.swift
//  blade
//
//  Created by sangya on 2021/9/1.
//

import Foundation
public struct PageInfo: Encodable,Decodable {
    public var name: String = ""
    public var id: String = ""
    public var arguments: [String: Int] = [String: Int]()
    public init(name: String, id: String, params: [String: Int]){
        self.name = name
        self.id = id
        self.arguments = params
    }
    public init(){
    }
}
