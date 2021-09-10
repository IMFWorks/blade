package com.imf.blade

import androidx.annotation.NonNull
import com.imf.blade.container.events.BackgroundEvent
import com.imf.blade.container.events.ForegroundEvent
import com.imf.blade.container.nativeEvents.*
import com.imf.blade.messager.FlutterChannel

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

  var delegate: NativeEventListener? = null

  override fun pushFlutterPage(event: PushFlutterPageEvent) {
    delegate?.pushFlutterPage(event)
  }

  override fun pushNativePage(event: PushNativePageEvent) {
    delegate?.pushNativePage(event)
  }

  override fun popNativePage(event: PopNativePageEvent) {
    delegate?.popNativePage(event)
  }

  override fun popUntilNativePage(event: PopUntilNativePageEvent) {
    delegate?.popUntilNativePage(event)
  }

  fun handleForegroundEvent() {
    flutterChannel.sendEvent(ForegroundEvent())
  }

  fun handleBackgroundEvent() {
    flutterChannel.sendEvent(BackgroundEvent())
  }
}