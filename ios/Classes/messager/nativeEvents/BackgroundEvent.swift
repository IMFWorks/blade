//
//  BackgroundEvent.swift
//  blade
//
//  Created by sangya on 2021/9/8.
//

import Foundation
public class BackgroundEvent:NativeBaseEvent {
    init(_ pageInfo:PageInfo?) {
        super.init()
        self.methodName = "background"
        self.pageInfo =  pageInfo
    }
}
