package com.example.plus_time

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.android.FlutterFragmentActivity
/*
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.support.v4.content.FileProvider

import java.io.File

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
*/
class MainActivity: FlutterFragmentActivity() {
    /*
    private val SHARE_CHANNEL = "channel:me.alfian.share/share"

    override fun onCreate(savedInstanceState: Bundle) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, SHARE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method.equals("shareFile")) {

                val imageFile = File(this.getApplicationContext().getCacheDir(), call.arguments)
                val contentUri = FileProvider.getUriForFile(this, "me.alfian.share", imageFile)
                val shareIntent = Intent(Intent.ACTION_SEND)
                shareIntent.setType("image/png")
                shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)

                this.startActivity(Intent.createChooser(shareIntent, "Share image using"))
            }
        }
    }
    */
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
