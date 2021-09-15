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
    init() {
        self.methodName = "background"
        self.pageInfo =  PageInfo()
    }
}
