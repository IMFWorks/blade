package com.imf.blade.container

import com.imf.blade.BladePlugin
import com.imf.blade.container.events.PushPageEvent
import com.imf.blade.messager.FlutterEventResponse
import com.imf.blade.messager.FlutterEventResponseListener
import com.imf.blade.messager.PageInfo

class ContainerLifecycleListener(private val container: FlutterViewContainer, private val plugin: BladePlugin) {

    fun handleAppeared() {
        val pageInfo = PageInfo(container.url, container.uniqueId, container.urlParams)
        val pushPageEvent = PushPageEvent(pageInfo)

        plugin.flutterChannel.sendEvent(pushPageEvent
            , object: FlutterEventResponseListener<FlutterEventResponse> {
            override fun success(response: FlutterEventResponse) {
                print("received response")
            }
        })
    }

    fun handleDisappeared() {

    }

    fun handleDestroyed() {

    }
}