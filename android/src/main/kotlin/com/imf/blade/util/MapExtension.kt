package com.imf.blade.util

fun Map<String, Any>.toHashMap(): HashMap<String,Any>? {
    if (this == null) {
        return null
    }

    val result = HashMap<String,Any>()
    forEach{(key, value) -> result[key] = value }
    return result
}