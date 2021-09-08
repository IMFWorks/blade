package com.imf.blade.container

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.imf.blade.Blade
import com.imf.blade.util.toMap

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.platform.PlatformPlugin
import java.util.*

interface ActivityResultListener {
    fun success(result: HashMap<String,Any>?)
    fun cancel()
}

open class BladeActivity : FlutterActivity(), FlutterViewContainer {
    private val who = UUID.randomUUID().toString()
    private var platformPlugin: PlatformPlugin? = null

    private lateinit var flutterView: FlutterView
    private lateinit var containerLifecycleListener: ContainerLifecycleListener

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val foundFlutterView = findFlutterView(window.decorView)
        foundFlutterView?.let {
            flutterView = it
        }

        containerLifecycleListener = ContainerLifecycleListener(this, Blade.shared().plugin)
    }

    // @Override
    override fun detachFromFlutterEngine() {
        /**
         * Override and do nothing.
         *
         * The idea here is to avoid releasing delegate when
         * a new FlutterActivity is attached in Flutter2.0.
         */
    }

    public override fun onResume() {
        super.onResume()

        // todo-wrs
        if (Build.VERSION.SDK_INT == Build.VERSION_CODES.Q) {
        }

        flutterEngine?.let {
            platformPlugin = PlatformPlugin(activity, it.platformChannel)
            attachToFlutterEngine(flutterView, it)
        }

        containerLifecycleListener.handlePushed();
        containerLifecycleListener.handleAppeared()
    }

    override fun onStop() {
        super.onStop()

        flutterEngine?.let {
            it.lifecycleChannel.appIsResumed()
        }
    }

    override fun onPause() {
        super.onPause()

        // todo-wrs
//        if (Build.VERSION.SDK_INT == Build.VERSION_CODES.Q) {
//            if (FlutterBoost.instance().isAppInBackground() &&
//                !FlutterContainerManager.instance().isTopContainer(uniqueId)
//            ) {
//                Log.w(
//                    TAG, "Unexpected activity lifecycle event on Android Q. " +
//                            "See https://issuetracker.google.com/issues/185693011 for more details."
//                )
//                return
//            }
//        }

        containerLifecycleListener.handleDisappeared()

        flutterEngine?.let {
            detachFromFlutterEngine(flutterView, it)
            it.lifecycleChannel.appIsResumed()
        }

        platformPlugin = null
    }

    override fun onDestroy() {
        flutterEngine?.let {
            it.lifecycleChannel.appIsResumed()
        }

        super.onDestroy()

        containerLifecycleListener.handleDestroyed()
    }

    var activityResultListener: ActivityResultListener? = null

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (resultCode == RESULT_OK) {
            val extras = data?.extras?.toMap()
            val result = extras?.get(LaunchConfigs.ACTIVITY_RESULT_KEY) as HashMap<String,Any>?
            activityResultListener?.success(result)
        } else {
            activityResultListener?.cancel()
        }
    }

    override fun shouldRestoreAndSaveState(): Boolean {
        return true;
    }

    override fun providePlatformPlugin(activity: Activity?, flutterEngine: FlutterEngine
    ): PlatformPlugin? {
        return null
    }

    override fun onBackPressed() {
        containerLifecycleListener.handlePopped()
        super.onBackPressed()
    }

    override fun getRenderMode(): RenderMode {
        return containerRenderMode()
    }

    override val contextActivity: Activity
        get() {return this}

    override fun finish(result: Map<String, Any>?) {
        if (result != null) {
            val intent = Intent()
            intent.putExtra(LaunchConfigs.ACTIVITY_RESULT_KEY, HashMap(result))
            setResult(RESULT_OK, intent)
        }

        finish()
    }

    override val url: String
        get() {
            if (!intent.hasExtra(LaunchConfigs.EXTRA_URL)) {
                throw RuntimeException(
                    "The activity url are null, You should set url via CachedEngineIntentBuilder."
                )
            }

            return intent.getStringExtra(LaunchConfigs.EXTRA_URL) as String
        }

    override val urlParams: Map<String, Any>?
        get() {
            return intent.getSerializableExtra(LaunchConfigs.EXTRA_URL_PARAM) as HashMap<String, Any>?
        }

    override val id: String
        get() {
            return if (!intent.hasExtra(LaunchConfigs.EXTRA_UNIQUE_ID)) {
                return who;
            } else intent.getStringExtra(LaunchConfigs.EXTRA_UNIQUE_ID) as String
        }

    override fun getCachedEngineId(): String {
        return Blade.ENGINE_ID;
    }

    companion object {
        private const val TAG = "BladeActivity"
    }

    class CachedEngineIntentBuilder(private val activityClass: Class<out BladeActivity?>) {
        private var destroyEngineWithActivity = false
        private var backgroundMode: String = LaunchConfigs.DEFAULT_BACKGROUND_MODE
        private var url: String? = null
        private var params: HashMap<String, Any>? = null
        private var uniqueId: String? = null
        fun destroyEngineWithActivity(destroyEngineWithActivity: Boolean): CachedEngineIntentBuilder {
            this.destroyEngineWithActivity = destroyEngineWithActivity
            return this
        }

        fun backgroundMode(backgroundMode: BackgroundMode): CachedEngineIntentBuilder {
            this.backgroundMode = backgroundMode.name
            return this
        }

        fun url(url: String?): CachedEngineIntentBuilder {
            this.url = url
            return this
        }

        fun urlParams(params: HashMap<String, Any>?): CachedEngineIntentBuilder {
            this.params = params
            return this
        }

        fun uniqueId(uniqueId: String?): CachedEngineIntentBuilder {
            this.uniqueId = uniqueId
            return this
        }

        fun build(context: Context?): Intent {
            return Intent(context, activityClass)
                .putExtra(LaunchConfigs.EXTRA_CACHED_ENGINE_ID, Blade.ENGINE_ID) // default engine
                .putExtra(LaunchConfigs.EXTRA_DESTROY_ENGINE_WITH_ACTIVITY, destroyEngineWithActivity)
                .putExtra(LaunchConfigs.EXTRA_BACKGROUND_MODE, backgroundMode)
                .putExtra(LaunchConfigs.EXTRA_URL, url)
                .putExtra(LaunchConfigs.EXTRA_URL_PARAM, params)
                .putExtra(LaunchConfigs.EXTRA_UNIQUE_ID, uniqueId)
        }
    }
}
