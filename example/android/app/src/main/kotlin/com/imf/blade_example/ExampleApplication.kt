package com.imf.blade_example

import android.content.Context
import android.content.Intent
import com.imf.blade.Blade
import com.imf.blade.BladeDelegate
import com.imf.blade.container.ActivityResultListener
import com.imf.blade.container.BladeActivity
import com.imf.blade.container.nativeEvents.PushFlutterPageEvent
import com.imf.blade.container.nativeEvents.PushNativePageEvent
import com.imf.blade.messager.PageInfo
import io.flutter.app.FlutterApplication
import java.util.HashMap

class ExampleApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        Blade.shared().setup(this, BladeDelegateImpl(this))
    }
}

class BladeDelegateImpl(val context: Context): BladeDelegate {
    var requestCode = 1000

    override fun pushNativePage(event: PushNativePageEvent) {
        val topActivity = Blade.shared().topActivity
        if (topActivity is BladeActivity) {
            topActivity.activityResultListener = object: ActivityResultListener{
                override fun success(result: HashMap<String, Any>?) {
                    event.result.success(result)
                }
                override fun cancel() {
                    event.result.success(null)
                }
            }
        }

        topActivity?.let {
            val intent = Intent(it, NativePageActivity::class.java)
            it.startActivityForResult(intent, requestCode++)
        }
    }

    override fun pushFlutterPage(event: PushFlutterPageEvent) {
        print("pushFlutterPage")
    }
}