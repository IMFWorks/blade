package com.imf.blade

import androidx.annotation.NonNull
import com.imf.blade.container.events.BackgroundEvent
import com.imf.blade.container.events.ForegroundEvent
import com.imf.blade.container.nativeEvents.NativeEventListener
import com.imf.blade.container.nativeEvents.PushFlutterPageEvent
import com.imf.blade.container.nativeEvents.PushNativePageEvent
import com.imf.blade.messager.FlutterChannel
import com.imf.blade.messager.FlutterEventResponse
import com.imf.blade.messager.FlutterEventResponseListener
import com.imf.blade.messager.ok

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** BladePlugin */
class BladePlugin: FlutterPlugin, NativeEventListener {
  var flutterContainerManager = FlutterContainerManager()
  lateinit var flutterChannel: FlutterChannel
  lateinit var platformCoordinator: PlatformCoordinator

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val binaryMessenger = flutterPluginBinding.binaryMessenger
    val name = "com.imf.blade"
    flutterChannel = FlutterChannel(binaryMessenger, name)
    platformCoordinator = PlatformCoordinator(binaryMessenger, flutterContainerManager, this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    platformCoordinator.release()
  }

  var delegate: BladeDelegate? = null

  override fun pushFlutterPage(event: PushFlutterPageEvent) {
    delegate?.pushFlutterPage(event.pageInfo)
    event.result.ok()
  }

  override fun pushNativePage(event: PushNativePageEvent) {
    delegate?.pushNativePage(event.pageInfo)
    event.result.ok()
  }

  fun handleForegroundEvent() {
    flutterChannel.sendEvent(ForegroundEvent())
  }

  fun handleBackgroundEvent() {
    flutterChannel.sendEvent(BackgroundEvent())
  }
}
