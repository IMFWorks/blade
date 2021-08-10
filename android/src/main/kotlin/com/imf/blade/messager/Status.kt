package com.imf.blade.messager

enum class Status(val value: Int) {
    OK(200),
    NO_CONTENT(204),
    NOT_FOUND(404),
    FATAL_ERROR(500)
}