//
//  PagePoppedEvent.swift
//  blade
//
//  Created by sangya on 2021/9/7.
//

import Foundation
public struct PagePoppedEvent:NativeBaseEvent {
    var methodName: String
    var pageInfo: PageInfo?
    init(_ pageInfo:PageInfo) {
        self.methodName = "pagePushed"
        self.pageInfo =  pageInfo
    }
}
