package com.imf.blade.container

import com.imf.blade.BladePlugin
import com.imf.blade.container.events.*
import com.imf.blade.messager.FlutterEvent
import com.imf.blade.messager.FlutterEventResponse
import com.imf.blade.messager.FlutterEventResponseListener
import com.imf.blade.messager.PageInfo

class ContainerLifecycleListener(val container: FlutterViewContainer, private val plugin: BladePlugin) {
    private val pageInfo = PageInfo(container.url, container.id, container.urlParams)

    fun handlePushed() {
        plugin.flutterContainerManager.addContainer(container)
        sendEvent(PagePushedEvent(pageInfo))
    }

    fun handleAppeared() {
        sendEvent(PageAppearedEvent(pageInfo))
        plugin.flutterContainerManager.topContainer = container
    }

    fun handleDisappeared() {
        sendEvent(PageDisappearedEvent(pageInfo))
    }

    fun handlePopped() {
        sendEvent(PagePoppedEvent(pageInfo));
    }

    fun handleDestroyed() {
        sendEvent(PageDestroyedEvent(pageInfo))
        plugin.flutterContainerManager.removeContainer(container.id)
    }

    fun handleForeground() {
        sendEvent(ForegroundEvent());
    }

    fun handleBackground() {
        sendEvent(BackgroundEvent());
    }

    private fun sendEvent(event: FlutterEvent) {
        plugin.flutterChannel.sendEvent(event, defaultListener)
    }

    private val defaultListener = object: FlutterEventResponseListener<FlutterEventResponse> {
        override fun success(response: FlutterEventResponse) {
            print("received response")
        }

        override fun failure(errorMessage: String?) {
            print("received $errorMessage")
        }
    }

    private inline fun <reified T: FlutterEventResponse> sendEvent(
        event: FlutterEvent
        , listener: FlutterEventResponseListener<T>) {
        plugin.flutterChannel.sendEvent(event, listener)
    }
}