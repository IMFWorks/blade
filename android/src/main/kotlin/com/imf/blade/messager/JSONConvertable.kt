package com.imf.blade.messager

import com.google.gson.Gson

interface JSONConvertable {
    fun toJSON(): String = Gson().toJson(this)
}

