package com.imf.blade.container.nativeEvents

interface NativeEventListener {
    fun pushFlutterPage(event: PushFlutterPageEvent)
    fun pushNativePage(event: PushNativePageEvent)
    fun popNativePage(event: PopNativePageEvent)
    fun popUntilNativePage(event: PopUntilNativePageEvent)
}