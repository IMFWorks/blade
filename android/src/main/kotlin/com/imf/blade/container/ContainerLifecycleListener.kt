package com.imf.blade.container

import com.imf.blade.BladePlugin
import com.imf.blade.container.events.*
import com.imf.blade.messager.FlutterEvent
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
        val resultPageInfo = PageInfo(pageInfo.name, pageInfo.id)
        sendEvent(PagePoppedEvent(resultPageInfo))
    }

    fun handleDestroyed() {
        sendEvent(PageDestroyedEvent(pageInfo))
        plugin.flutterContainerManager.removeContainer(container.id)
    }

    private fun sendEvent(event: FlutterEvent) {
        plugin.flutterChannel.sendEvent(event)
    }
}