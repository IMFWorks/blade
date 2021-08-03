package com.imf.blade

import com.imf.blade.messager.PageInfo

interface BladeDelegate {
    fun pushNativePage(pageInfo: PageInfo)
    fun pushFlutterPage(pageInfo: PageInfo)
}