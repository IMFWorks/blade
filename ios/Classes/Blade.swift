//
//  Blade.swift
//  blade
//
//  Created by sangya on 2021/8/31.
//
import Flutter
import Foundation

public class Blade {
    static public let shared = Blade()
    private init() {}
    var engine: FlutterEngine = FlutterEngine(name: "io.flutter")
    private var plugin: BladePlugin?

    public func setup(application: UIApplication, delegate: BladeDelegate) {
        self.engine.run(withEntrypoint: "main", initialRoute: "flutterPage")
        if let register = engine.registrar(forPlugin: "BladePlugin") {
            BladePlugin.register(with: register)
        }
        self.plugin = BladePlugin.getPlugin(engine: engine)
        self.plugin?.delegate = delegate
        self.registerNotification()
    }
    
    var delegate:BladeDelegate? {
        return self.plugin?.delegate
    }
    
    var channel: FlutterChannel? {
        return self.plugin?.channel
    }
    
    var containerManager:FlutterContainerManager? {
        return self.plugin?.containerManager
    }
    
    var navigationController:UINavigationController? {
        return plugin?.delegate?.navigationController
    }
    
    func pushFlutterPage(event: FlutterBaseEvent){
        plugin?.pushFlutterPage(event: event)
    }
    
    func pushNativePage(event: FlutterBaseEvent){
        plugin?.pushNativePage(event: event)
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) {_ in
            Blade.shared.channel?.sendEvent(event: ForegroundEvent())
        }
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: OperationQueue.main) {_ in
            Blade.shared.channel?.sendEvent(event: BackgroundEvent())
        }
    }
    
    func unsetBlade(){
        NotificationCenter.default.removeObserver(self)
    }
}
