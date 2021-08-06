package com.imf.blade.messager

import com.google.gson.Gson

interface JSONConvertible {
    fun toJSON(): String = Gson().toJson(this)
}

