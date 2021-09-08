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
        Blade.shared.navigationController?.popViewController(animated: true)
    }
    // TODO
    func addContainer(container:FlutterViewContainer,uniqueId:String){
        allContainers[uniqueId] = container
    }
    func removeContainerByUniqueId(uniqueId:String){
        allContainers.removeValue(forKey: uniqueId)
    }
}
