package com.imf.blade.messager

import java.util.*

class PageInfo (
    val name: String,
    private val id: String,
    private val arguments: Map<String, Any?>? = null): JSONConvertable {
}