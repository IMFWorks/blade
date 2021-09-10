package com.imf.blade

import com.imf.blade.container.FlutterViewContainer
import java.util.*

class FlutterContainerManager {
    private val containers = HashMap<String, FlutterViewContainer>()
    var topContainer: FlutterViewContainer? = null

    fun addContainer(container: FlutterViewContainer) {
        containers[container.id] = container
    }

    fun removeContainer(id: String) {
        containers.remove(id)

        topContainer?.let {
            if (it.id == id) {
                topContainer = null
            }
        }
    }

    fun getContainerById(id: String ): FlutterViewContainer? {
        return containers.get(id)
    }
}
