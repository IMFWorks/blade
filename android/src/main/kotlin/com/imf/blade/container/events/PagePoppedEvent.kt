package com.imf.blade.container.events

import com.imf.blade.messager.FlutterEvent
import com.imf.blade.messager.PageInfo

class PagePoppedEvent(pageInfo: PageInfo): FlutterEvent("pagePopped", pageInfo) {
}