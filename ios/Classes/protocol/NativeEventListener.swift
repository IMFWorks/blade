//
//  NativeEventListener.swift
//  blade
//
//  Created by sangya on 2021/8/31.
//

import Foundation
public protocol NativeEventListener {
    func pushFlutterPage(event: FlutterBaseEvent)
    func pushNativePage(event: FlutterBaseEvent)
}
