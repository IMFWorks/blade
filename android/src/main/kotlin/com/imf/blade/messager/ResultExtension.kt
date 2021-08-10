package com.imf.blade.messager

import com.google.gson.Gson
import com.imf.blade.container.nativeEvents.NativeEventResponse
import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.fatalError() {
    error(Status.FATAL_ERROR.name, "call.arguments is not String", null)
}

fun MethodChannel.Result.ok() {
    val response = NativeEventResponse(Status.OK.value)
    success(Gson().toJson(response))
}

fun MethodChannel.Result.noContent() {
    val response = NativeEventResponse(Status.NOT_FOUND.value)
    success(Gson().toJson(response))
}