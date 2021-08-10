package com.imf.blade.container.nativeEvents

import com.google.gson.Gson
import com.imf.blade.messager.PageInfo
import io.flutter.plugin.common.MethodChannel

class PopNativePageEvent(result: MethodChannel.Result, val pageInfo: PageInfo ): NativeEvent(result) {
    companion object {
        fun decode(json: String, result: MethodChannel.Result): PopNativePageEvent {
            val pageInfo = Gson().fromJson(json, PageInfo::class.java)
            return PopNativePageEvent(result, pageInfo)
        }
    }
}