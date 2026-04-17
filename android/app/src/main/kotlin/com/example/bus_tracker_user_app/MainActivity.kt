package com.bus_tracker_user_app.app

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
	override fun onCreate(savedInstanceState: Bundle?) {
		// Uses AndroidX edge-to-edge APIs on Android 15+, avoiding deprecated window color setters.
		enableEdgeToEdge()
		super.onCreate(savedInstanceState)
	}
}
