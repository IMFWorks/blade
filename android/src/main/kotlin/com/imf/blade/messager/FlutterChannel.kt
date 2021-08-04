package com.imf.blade.messager

import com.google.gson.Gson
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class FlutterChannel(messenger: BinaryMessenger, name: String) {
    val channel = MethodChannel(messenger, name)
    val gson = Gson()

    inline fun <reified T: FlutterEventResponse> sendEvent(
        event: FlutterEvent
        , listener: FlutterEventResponseListener<T>) {
        channel.invokeMethod(event.methodName, event.toJSON(), object: MethodChannel.Result {

            override fun success(result: Any?) {
                if (result is String) {
                    val response = gson.fromJson(result, T::class.java)
                    listener.success(response)
                } else {
                    listener.failure("response data is not String")
                }
            }

            override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                listener.failure(errorMessage)
            }

            override fun notImplemented() {
                listener.failure("not implemented")
            }
        })
    }
}

interface FlutterEventResponseListener<T> {
    fun success(response: T) {

    }

    fun failure(errorMessage: String?) {

    }
}
