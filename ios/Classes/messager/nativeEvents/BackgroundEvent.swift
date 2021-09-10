//
//  BackgroundEvent.swift
//  blade
//
//  Created by sangya on 2021/9/8.
//

import Foundation
public struct BackgroundEvent:NativeBaseEvent {
    var methodName: String
    var pageInfo: PageInfo?
    init(_ pageInfo:PageInfo?) {
        self.methodName = "background"
        self.pageInfo =  pageInfo
    }
}
