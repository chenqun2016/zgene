package com.jt.zgene

import android.content.Intent
import android.os.Bundle
import android.util.Log

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.jt.zgene.MethodChannel"
    private var methodChannel : MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        methodChannel = MethodChannel(flutterEngine?.dartExecutor, CHANNEL)
        //获取自定义透传参数值
        Log.d("--------------", "onCreate")
        checkPushIntent(intent)
    }

    override fun onRestart() {
        super.onRestart()
        //获取自定义透传参数值
        Log.d("--------------", "onRestart")
        checkPushIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("--------------", "onNewIntent")
        checkPushIntent(intent)
    }

    private fun checkPushIntent(intent: Intent) {
        if (null != intent) {
            val url = intent.getStringExtra("url")
            val type = intent.getStringExtra("type")
            Log.d("--------------", "url = " + url + ",type = " + type)
            if (null != url && url.isNotEmpty()) {
                intent.putExtra("url", "")
                intent.putExtra("type", "")
                val map = mapOf("url" to url, "type" to type)
                methodChannel?.invokeMethod("onPushData", map)
            }
        }
    }
}
