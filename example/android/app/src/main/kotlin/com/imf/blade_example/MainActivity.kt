package com.imf.blade_example

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.imf.blade.container.BladeActivity

class MainActivity :AppCompatActivity() {
    private lateinit var mOpenFlutter: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.main_page)
        mOpenFlutter = findViewById<TextView>(R.id.open_flutter)
        mOpenFlutter.setOnClickListener {
            openFlutterPage()
        }
    }

    private fun openFlutterPage() {
        val params: HashMap<String,Any> = HashMap<String,Any>()
        params.put("1","Python")

        val intent = BladeActivity.CachedEngineIntentBuilder(FlutterBladeActivity::class.java)
            .destroyEngineWithActivity(false)
            .url("flutterPage")
            .uniqueId("1234")
            .urlParams(params)
            .build(this)



        startActivity(intent)
    }
}