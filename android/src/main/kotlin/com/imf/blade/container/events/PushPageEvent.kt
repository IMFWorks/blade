package com.imf.blade.container.events

import com.imf.blade.messager.FlutterEvent
import com.imf.blade.messager.PageInfo

class PushPageEvent(private val pageInfo: PageInfo
): FlutterEvent("pushPage", pageInfo) {

}



