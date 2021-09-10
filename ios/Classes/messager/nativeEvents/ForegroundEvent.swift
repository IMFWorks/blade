//
//  ForegroundEvent.swift
//  blade
//
//  Created by sangya on 2021/9/8.
//

import Foundation
public struct ForegroundEvent:NativeBaseEvent {
    var methodName: String
    var pageInfo: PageInfo?
    init(_ pageInfo:PageInfo?) {
        self.methodName = "foreground"
        self.pageInfo =  pageInfo
    }
}
