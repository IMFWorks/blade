package com.imf.blade.container.events

import com.imf.blade.messager.FlutterEvent
import com.imf.blade.messager.NOPPayload

class ForegroundEvent(): FlutterEvent("foreground", NOPPayload()) {

}