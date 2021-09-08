//
//  PageDisappearedEvent.swift
//  blade
//
//  Created by sangya on 2021/9/7.
//

import Foundation
public class PageDisappearedEvent:NativeBaseEvent {
    init(_ pageInfo:PageInfo?) {
        super.init()
        self.methodName = "pageDisappeared"
        self.pageInfo =  pageInfo
    }
}
