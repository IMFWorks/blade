package com.imf.blade

import com.google.gson.Gson
import com.imf.blade.container.FlutterViewContainer
import com.imf.blade.container.nativeEvents.NativeEventResponse
import com.imf.blade.container.nativeEvents.PopNativePageEvent
import com.imf.blade.messager.Status
import com.imf.blade.messager.ok
import java.util.*

class FlutterContainerManager {
    private val  gson = Gson()
    private val containers = HashMap<String, FlutterViewContainer>()
    var topContainer: FlutterViewContainer? = null

    fun addContainer(container: FlutterViewContainer) {
        containers[container.id] = container
    }

    fun removeContainer(id: String) {
        containers.remove(id)

        topContainer?.let {
            if (it.id == id) {
                topContainer = null;
            }
        }
    }

    fun getContainerById(id: String ): FlutterViewContainer? {
        return containers.get(id)
    }

    fun handlePopNativePageEvent(event: PopNativePageEvent) {
        val container = getContainerById(event.pageInfo.id)
        container?.let {
            it.finish(event.pageInfo.arguments)
        }

        event.result.ok()
    }
}
