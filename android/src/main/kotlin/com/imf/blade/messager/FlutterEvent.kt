package com.imf.blade.messager

open class FlutterEvent(val methodName: String, private val payload: JSONConvertible): JSONConvertible{
    override fun toJSON(): String {
        return payload.toJSON()
    }
}

class NOPPayload: JSONConvertible {

}