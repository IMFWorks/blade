//
//  PagePoppedEvent.swift
//  blade
//
//  Created by sangya on 2021/9/7.
//

import Foundation

public class PagePoppedEvent:NativeBaseEvent {
    init(_ pageInfo:PageInfo) {
        super.init()
        self.methodName = "pagePushed"
        self.pageInfo =  pageInfo
    }
}
