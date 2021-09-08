//
//  BladeDelegate.swift
//  blade
//
//  Created by sangya on 2021/8/31.
//

import Foundation
public protocol BladeDelegate {
    var navigationController:UINavigationController? { get set }
    func pushNativePage(event: FlutterBaseEvent)
    func pushFlutterPage(event: FlutterBaseEvent)
}
