package com.imf.blade.util

import android.os.Bundle

fun Bundle.toMap(): HashMap<String,Any>? {

    val keys = keySet()
    if (keys.size == 0) {
        return null
    }

    val result = HashMap<String,Any>()
    keys.forEach {
        val value = get(it)
        if (value != null) {
            result[it] = value
        }
    }

    return result
}