package com.imf.blade_example

import android.content.Context
import android.content.Intent
import com.imf.blade.Blade
import com.imf.blade.BladeDelegate
import com.imf.blade.messager.PageInfo
import io.flutter.app.FlutterApplication

class ExampleApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        Blade.shared().setup(this, BladeDelegateImpl(this))
    }
}

class BladeDelegateImpl(val context: Context): BladeDelegate {

    override fun pushNativePage(pageInfo: PageInfo) {
        val topActivity = Blade.shared().topActivity
        topActivity?.let {
//            val intent = Intent(it, NativePageActivity::class.java)
//            it.startActivityForResult(intent, 100)
        }
    }

    override fun pushFlutterPage(pageInfo: PageInfo) {
        print("pushFlutterPage")
    }
}