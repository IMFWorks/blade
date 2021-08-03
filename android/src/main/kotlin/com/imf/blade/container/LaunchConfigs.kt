package com.imf.blade.container

import io.flutter.embedding.android.FlutterActivityLaunchConfigs

class LaunchConfigs {

    companion object {
        // Intent extra arguments.
        const val EXTRA_BACKGROUND_MODE = "background_mode"
        const val EXTRA_CACHED_ENGINE_ID = "cached_engine_id"
        const val EXTRA_DESTROY_ENGINE_WITH_ACTIVITY = "destroy_engine_with_activity"
        const val EXTRA_ENABLE_STATE_RESTORATION = "enable_state_restoration"
        const val EXTRA_URL = "url"
        const val EXTRA_URL_PARAM = "url_param"
        const val EXTRA_UNIQUE_ID = "unique_id"
        val DEFAULT_BACKGROUND_MODE = FlutterActivityLaunchConfigs.BackgroundMode.opaque.name

        // for onActivityResult
        const val ACTIVITY_RESULT_KEY = "ActivityResult"
    }
}