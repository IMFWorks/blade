package com.imf.blade_example

import com.imf.blade.Blade
import com.imf.blade.BladeDelegate
import com.imf.blade.messager.PageInfo
import io.flutter.app.FlutterApplication
import kotlin.math.log

class ExampleApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        Blade.shared().setup(this, BladeDelegateImpl())
    }
}

class BladeDelegateImpl: BladeDelegate {
    override fun pushNativePage(pageInfo: PageInfo) {

    }

    override fun pushFlutterPage(pageInfo: PageInfo) {

    }
}