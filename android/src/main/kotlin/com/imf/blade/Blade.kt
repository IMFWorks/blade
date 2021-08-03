package com.imf.blade

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import io.flutter.view.FlutterMain

class Blade {

    companion object {
        const val ENGINE_ID = "blade_shared_engine_id"

        public fun shared(): Blade {
            return LazyHolder.INSTANCE
        }
    }

    private val defaultInitialRoute = "/"
    private val defaultDartEntrypointFunctionName = "main"

    private lateinit var engine: FlutterEngine
    private var cachedPlugin: BladePlugin? = null


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
            cachedEngine.dartExecutor.executeDartEntrypoint(dartEntrypoint);
            engine = cachedEngine;
            FlutterEngineCache.getInstance().put(ENGINE_ID, cachedEngine)
        }
        // 2. set delegate
        //getPlugin().setDelegate(delegate)

        //3. register ActivityLifecycleCallbacks
        //setupActivityLifecycleCallback(application, isBackForegroundEventOverridden)
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
                cachedPlugin = plugin;
            }

            return cachedPlugin!!
        }
}