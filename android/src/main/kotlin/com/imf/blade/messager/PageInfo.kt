package com.imf.blade.messager

data class PageInfo (
    val name: String,
    val id: String,
    val arguments: Map<String, Any>? = null): JSONConvertible {
}