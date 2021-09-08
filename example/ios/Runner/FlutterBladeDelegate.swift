//
//  FlutterBladeDelegate.swift
//  Runner
//
//  Created by sangya on 2021/8/31.
//

import UIKit
import blade
class FlutterBladeDelegate: NSObject,BladeDelegate {
    var navigationController: UINavigationController?
    
    func pushNativePage(event: FlutterBaseEvent) {
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }

    func pushFlutterPage(event: FlutterBaseEvent) {
        let vc = FlutterViewContainer()
        if let info = event.payload {
            vc.setPageInfo(info)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
