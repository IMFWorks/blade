import Flutter
import UIKit

public class BladePlugin: NSObject, FlutterPlugin,NativeEventListener {
    
    var delegate: BladeDelegate?
    var channel: FlutterChannel?
    var coordinator:PlatformCoordinator?
    var containerManager:FlutterContainerManager?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.imf.blade", binaryMessenger: registrar.messenger())
        let instance = BladePlugin()
        instance.containerManager = FlutterContainerManager()
        instance.coordinator = PlatformCoordinator(channel: channel)
        instance.channel = FlutterChannel(messager: registrar.messenger(),channel: channel)
        registrar.publish(instance)
    }

    public func pushFlutterPage(event: FlutterBaseEvent) {
        delegate?.pushFlutterPage(event: event)
    }
    
    public func pushNativePage(event: FlutterBaseEvent) {
        delegate?.pushNativePage(event: event)
    }
    
    static func getPlugin(engine:FlutterEngine?) -> BladePlugin?{
        let published = engine?.valuePublished(byPlugin: "BladePlugin")
        if let plugin = published as? BladePlugin {
            return plugin
        }
        return nil
    }
    
    static var plugin: BladePlugin? {
        return BladePlugin.getPlugin(engine: Blade.shared.engine)
    }
}
