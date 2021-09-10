package com.imf.blade_example

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.imf.blade.Blade
import com.imf.blade.BladeDelegate
import com.imf.blade.container.ActivityResultListener
import com.imf.blade.container.BladeActivity
import com.imf.blade.container.nativeEvents.NativeEvent
import com.imf.blade.container.nativeEvents.PopUntilNativePageEvent
import com.imf.blade.container.nativeEvents.PushFlutterPageEvent
import com.imf.blade.container.nativeEvents.PushNativePageEvent
import com.imf.blade.messager.FlutterEvent
import com.imf.blade.messager.PageInfo
import com.imf.blade.util.toHashMap
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


        topActivity?.let {
            val intent = Intent(it, NativePageActivity::class.java)
            it.startActivityForResult(intent, requestCode++)
        }

        handleResult(event, topActivity);
    }

    override fun pushFlutterPage(event: PushFlutterPageEvent) {
        val pageInfo = event.pageInfo
        val topActivity = Blade.shared().topActivity

        val intent = BladeActivity.CachedEngineIntentBuilder(FlutterBladeActivity::class.java)
            .destroyEngineWithActivity(false)
            .url(pageInfo.name)
            .uniqueId(pageInfo.id)
            .urlParams(event.pageInfo.arguments?.toHashMap())
            .build(topActivity)

        topActivity?.startActivityForResult(intent, requestCode++)
        handleResult(event, topActivity)
    }

    private fun handleResult(event: NativeEvent, targetActivity: Activity?) {
        if (targetActivity is BladeActivity) {
            targetActivity.activityResultListener = object: ActivityResultListener{
                override fun success(result: HashMap<String, Any>?) {
                    event.result.success(result)
                }
                override fun cancel() {
                    event.result.success(null)
                }
            }
        }
        else {
            event.result.success(null)
        }
    }
}