package com.imf.blade_example

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView
import com.imf.blade.container.BladeActivity
import com.imf.blade.container.LaunchConfigs

class NativePageActivity : AppCompatActivity() {
    private lateinit var mOpenFlutter: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_native_page)

        mOpenFlutter = findViewById<TextView>(R.id.open_flutter)
        mOpenFlutter.setOnClickListener {
            openFlutterPage()
        }
    }

    private fun openFlutterPage() {
        val params = HashMap<String,Any>()
        params["name"] = "Python"

        val intent = BladeActivity.CachedEngineIntentBuilder(FlutterBladeActivity::class.java)
            .destroyEngineWithActivity(false)
            .url("flutterPage")
            .uniqueId("123456")
            .urlParams(params)
            .build(this)

        startActivity(intent)
    }

    override fun finish() {
        val intent = Intent()
        val result = HashMap<String,Any>()
        result["name"] = "Python"
        intent.putExtra(LaunchConfigs.ACTIVITY_RESULT_KEY, result)
        setResult(RESULT_OK, intent)

        super.finish()
    }
}