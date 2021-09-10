package com.imf.blade

import android.app.Activity
import android.app.Application
import android.app.Application.ActivityLifecycleCallbacks
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import com.imf.blade.container.LaunchConfigs
import com.imf.blade.container.nativeEvents.*
import com.imf.blade.messager.ok
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import io.flutter.view.FlutterMain

class Blade {

    companion object {
        const val ENGINE_ID = "blade_shared_engine_id"

        fun shared(): Blade {
            return LazyHolder.INSTANCE
        }
    }

    private val defaultInitialRoute = "/"
    private val defaultDartEntrypointFunctionName = "main"

    private lateinit var engine: FlutterEngine
    private var cachedPlugin: BladePlugin? = null
    var topActivity: Activity? = null
    private val stacks = ArrayList<ActivityInfo>()


    private constructor()

    private object LazyHolder {
        val INSTANCE: Blade = Blade()
    }

    /**
     * Initializes engine and plugin.
     *
     * @param application the application
     * @param delegate    the BladeDelegate
     */
    fun setup(application: Application, delegate: BladeDelegate) {
        // 1. initialize default engine
        var cachedEngine = FlutterEngineCache.getInstance()[ENGINE_ID]
        if (cachedEngine == null) {
            cachedEngine = FlutterEngine(application)
            cachedEngine.navigationChannel.setInitialRoute(defaultInitialRoute)
            val dartEntrypoint = DartEntrypoint(
                FlutterMain.findAppBundlePath(), defaultDartEntrypointFunctionName
            );
            cachedEngine.dartExecutor.executeDartEntrypoint(dartEntrypoint)
            engine = cachedEngine
            FlutterEngineCache.getInstance().put(ENGINE_ID, cachedEngine)
        }

        // 2. set delegate
        setDelegate(delegate)

        //3. register ActivityLifecycleCallbacks
        registerActivityLifecycleCallbacks(application)
    }

    /**
     * Gets the BladePlugin.
     *
     * @return the BladePlugin.
     */
    val plugin: BladePlugin
        get () {
            if (cachedPlugin == null) {
                val pluginClass =
                    Class.forName("com.imf.blade.BladePlugin") as Class<out BladePlugin>
                val plugin: BladePlugin = engine.plugins[pluginClass] as BladePlugin?
                    ?: throw  Exception("BladePlugin is not existed")
                cachedPlugin = plugin
            }

            return cachedPlugin!!
        }

    private fun setDelegate(delegate: BladeDelegate) {
        plugin.delegate = object: NativeEventListener {
            override fun pushFlutterPage(event: PushFlutterPageEvent) {
                delegate.pushFlutterPage(event)
            }

            override fun pushNativePage(event: PushNativePageEvent) {
                delegate.pushNativePage(event)
            }

            override fun popNativePage(event: PopNativePageEvent) {
                val container = plugin.flutterContainerManager.getContainerById(event.pageInfo.id)
                container?.let {
                    it.finish(event.pageInfo.arguments)
                }

                event.result.ok()
            }

            override fun popUntilNativePage(event: PopUntilNativePageEvent) {
                val index = stacks.indexOfLast { activityInfo -> activityInfo.name == event.pageInfo.name }
                val lastCount = stacks.size - index - 1
                if (lastCount > 0 ) {
                    val pendingPoppedActivityList = stacks.takeLast(lastCount)
                    pendingPoppedActivityList.forEach { activityInfo ->
                        activityInfo.activity.finish()
                    }
                }

                event.result.ok()
            }
        }
    }

    private class ActivityInfo(val name: String, val activity: Activity)

    private fun registerActivityLifecycleCallbacks(application: Application) {
       application.registerActivityLifecycleCallbacks(object: ActivityLifecycleCallbacks{
           private var activityReferences = 0
           private var isActivityChangingConfigurations = false
           var isAppInBackground = false

           private fun dispatchForegroundEvent() {
               isAppInBackground = false
               plugin.handleForegroundEvent()
           }

           private fun dispatchBackgroundEvent() {
               isAppInBackground = true
               plugin.handleBackgroundEvent()
           }

           override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
               topActivity = activity

               val name = activity.intent.extras?.get(LaunchConfigs.EXTRA_URL) as String? ?: activity.javaClass.name
               var activityInfo = ActivityInfo(name, activity)
               stacks.add(activityInfo)
           }

           override fun onActivityStarted(activity: Activity) {
               if (++activityReferences == 1 && !isActivityChangingConfigurations) {
                   // App enters foreground
                   dispatchForegroundEvent()
               }
           }

           override fun onActivityResumed(activity: Activity) {
               topActivity = activity
           }

           override fun onActivityPaused(activity: Activity) {}
           override fun onActivityStopped(activity: Activity) {
               isActivityChangingConfigurations = activity.isChangingConfigurations
               if (--activityReferences == 0 && !isActivityChangingConfigurations) {
                   // App enters background
                   dispatchBackgroundEvent()
               }
           }

           override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
           }

           @RequiresApi(Build.VERSION_CODES.N)
           override fun onActivityDestroyed(activity: Activity) {
               val name = activity.intent.extras?.get(LaunchConfigs.EXTRA_URL) as String? ?: activity.javaClass.name
               val foundActivity = stacks.reversed().first {activityInfo -> activityInfo.name == name }
               foundActivity?.let {
                   stacks.remove(it)
               }
           }
       })
    }
}