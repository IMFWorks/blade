//
//  ForegroundEvent.swift
//  blade
//
//  Created by sangya on 2021/9/8.
//

import Foundation
public class ForegroundEvent:NativeBaseEvent {
    init(_ pageInfo:PageInfo?) {
        super.init()
        self.methodName = "foreground"
        self.pageInfo =  pageInfo
    }
}
