//
//  FlutterContainerManager.swift
//  blade
//
//  Created by sangya on 2021/9/1.
//

import Foundation
public class FlutterContainerManager {
    var allContainers = [String:FlutterViewContainer]()
    func handlePopNativePageEvent(_ event: FlutterBaseEvent){
        if let topViewController = Blade.shared.navigationController?.viewControllers.last as? FlutterViewContainer {
            topViewController.popResult = event.result
            Blade.shared.navigationController?.popViewController(animated: true)
        }
    }
    
    func popUntilNativePage(_ event: FlutterBaseEvent) {
        guard var viewControllers = Blade.shared.navigationController?.viewControllers else {
            event.result?(["msg":"popUtil id not found"])
            return
        }
        viewControllers.reverse()
        var popFlutterController:FlutterViewContainer?
        for controller in viewControllers {
            guard let flutterController = controller as? FlutterViewContainer else {
                continue
            }
            if flutterController.pageInfo?.name == event.payload?.name {
                popFlutterController = flutterController
                break
            }
        }
        guard let viewController = popFlutterController else {
            event.result?(["msg":"popUtil id not found"])
            return
        }
        viewController.popResult = event.result
        Blade.shared.navigationController?.popToViewController(viewController, animated: true)
    }
    
    // TODO
    func addContainer(container:FlutterViewContainer,uniqueId:String){
        allContainers[uniqueId] = container
    }
    
    func removeContainerByUniqueId(uniqueId:String){
        allContainers.removeValue(forKey: uniqueId)
    }
}
