package com.imf.blade.messager

class PageInfo (
    val name: String,
    private val id: String,
    private val arguments: Map<String, Any?>? = null): JSONConvertible {
}