package com.inmotion.inmotion_mobile_test

import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        //MapKitFactory.setLocale("YOUR_LOCALE") // Your preferred language. Not required, defaults to system language
        MapKitFactory.setApiKey("dde8b26c-6503-4842-84d1-d89ada515e45") // Your generated API key
    }
}