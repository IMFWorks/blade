//
//  PageAppearedEvent.swift
//  blade
//
//  Created by sangya on 2021/9/8.
//

import Foundation
public class PageAppearedEvent:NativeBaseEvent {
    init(_ pageInfo:PageInfo?) {
        super.init()
        self.methodName = "pageAppeared"
        self.pageInfo =  pageInfo
    }
}
