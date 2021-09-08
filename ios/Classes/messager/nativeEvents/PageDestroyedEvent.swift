//
//  PageDestroyedEvent.swift
//  blade
//
//  Created by sangya on 2021/9/7.
//

import Foundation
public class PageDestroyedEvent:NativeBaseEvent {
    init(_ pageInfo:PageInfo?) {
        super.init()
        self.methodName = "pageDestroyed"
        self.pageInfo =  pageInfo
    }
}
