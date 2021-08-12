package com.imf.blade

import android.app.Activity
import android.app.Application.ActivityLifecycleCallbacks
import android.os.Bundle

class BladeActivityLifecycle(val blade: Blade): ActivityLifecycleCallbacks {
    private var activityReferences = 0
    private var isActivityChangingConfigurations = false
    var isAppInBackground = false

    private fun dispatchForegroundEvent() {
        isAppInBackground = false
        blade.plugin.handleForegroundEvent()
    }

    private fun dispatchBackgroundEvent() {
        isAppInBackground = true
        blade.plugin.handleBackgroundEvent()
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        blade.topActivity = activity
    }

    override fun onActivityStarted(activity: Activity) {
        if (++activityReferences == 1 && !isActivityChangingConfigurations) {
            // App enters foreground
            dispatchForegroundEvent()
        }
    }

    override fun onActivityResumed(activity: Activity) {
        blade.topActivity = activity
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

    override fun onActivityDestroyed(activity: Activity) {
    }
}