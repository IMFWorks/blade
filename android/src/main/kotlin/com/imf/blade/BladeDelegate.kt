package com.imf.blade

import com.imf.blade.container.nativeEvents.PushFlutterPageEvent
import com.imf.blade.container.nativeEvents.PushNativePageEvent
import com.imf.blade.messager.PageInfo

interface BladeDelegate {
    fun pushNativePage(event: PushNativePageEvent)
    fun pushFlutterPage(event: PushFlutterPageEvent)
}