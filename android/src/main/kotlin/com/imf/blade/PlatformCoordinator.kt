package com.imf.blade

import com.imf.blade.container.nativeEvents.NativeEventListener
import com.imf.blade.container.nativeEvents.PopNativePageEvent
import com.imf.blade.container.nativeEvents.PushFlutterPageEvent
import com.imf.blade.container.nativeEvents.PushNativePageEvent
import com.imf.blade.messager.Status
import com.imf.blade.messager.fatalError
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

typealias EventHandler = (MethodCall, MethodChannel.Result) -> Unit

class PlatformCoordinator(messenger: BinaryMessenger,
                          private val flutterContainerManager: FlutterContainerManager,
                          nativeEventListener: NativeEventListener): NativeEventListener by nativeEventListener {
    private val channel = MethodChannel(messenger, "com.imf.blade")
    private val handlers = HashMap<String, EventHandler>()

    init {
        setupHandlers()

        channel.setMethodCallHandler{ call, result ->
            val handler = handlers[call.method]
            if (handler != null) {
                handler(call, result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setupHandlers() {
        handlers["popNativePage"] = {call, result ->
            if (call.arguments is String) {
                val event = PopNativePageEvent.decode(call.arguments as String, result)
                flutterContainerManager.handlePopNativePageEvent(event)
            } else {
                result.fatalError()
            }
        }

        handlers["pushNativePage"] = {call, result ->
            if (call.arguments is String) {
                val event = PushNativePageEvent.decode(call.arguments as String, result)
                pushNativePage(event);
            } else {
                result.fatalError()
            }
        }

        handlers["pushFlutterPage"] = {call, result ->
            if (call.arguments is String) {
                val event = PushFlutterPageEvent.decode(call.arguments as String, result)
                pushFlutterPage(event)
            } else {
                result.fatalError()
            }
        }
    }

    fun release() {
        channel.setMethodCallHandler(null)
    }
}