package com.jt.zgene

import android.os.Bundle
import com.umeng.commonsdk.UMConfigure
import com.umeng.umeng_common_sdk.UmengCommonSdkPlugin
import io.flutter.embedding.android.FlutterActivity
class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //友盟统计
        UMConfigure.setLogEnabled(true)
        UMConfigure.preInit(this, "614d843866b59330aa6f3255", "zgene")
        UmengCommonSdkPlugin.setContext(this)
    }
}
