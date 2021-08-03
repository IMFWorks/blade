package com.imf.blade.messager

open class FlutterEvent(val methodName: String, private val payload: JSONConvertable) : JSONConvertable {
    override fun toJSON(): String {
        return payload.toJSON()
    }
}