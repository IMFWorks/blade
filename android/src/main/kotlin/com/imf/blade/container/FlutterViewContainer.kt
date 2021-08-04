package com.imf.blade.container

import android.app.Activity
import android.view.View
import android.view.ViewGroup
import com.imf.blade.Blade
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine

interface FlutterViewContainer {
    val contextActivity: Activity
    val url: String
    val urlParams: Map<String, Any?>?
    val uniqueId: String
    fun finish(result: Map<String, Any>?)
}

fun FlutterViewContainer.findFlutterView(view: View?): FlutterView? {
    if (view is FlutterView) {
        return view
    }

    if (view is ViewGroup) {
        for (i in 0 until view.childCount) {
            val child = view.getChildAt(i)
            val flutterView = findFlutterView(child)
            if (flutterView != null) {
                return flutterView
            }
        }
    }

    return null
}

fun FlutterViewContainer.attachToFlutterEngine(flutterView: FlutterView, flutterEngine: FlutterEngine) {
    flutterView.attachToFlutterEngine(flutterEngine)
    flutterEngine.lifecycleChannel.appIsResumed()
}

/**
 * 添加 detachFromFlutterEngine
 *
 * @param flutterView
 */
fun FlutterViewContainer.detachFromFlutterEngine(flutterView: FlutterView, flutterEngine: FlutterEngine) {
    flutterView.detachFromFlutterEngine()
    flutterEngine.lifecycleChannel.appIsInactive()
}

fun FlutterViewContainer.containerRenderMode(): RenderMode {
    return RenderMode.texture
}

fun FlutterViewContainer.containerBackPressed() {
    //Blade.shared().plugin.popRoute(null, null)
}
