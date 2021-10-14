package com.jt.zgene

import android.content.Intent 
import android.os.Bundle
import android.util.Log

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //获取自定义透传参数值
            val url  = intent.getStringExtra("url")
            val id   = intent.getStringExtra("id")
            Log.d("--------------", "url = " + url + ",id = " + id)
        
    }
     
}
