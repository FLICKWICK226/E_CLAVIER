package com.eclavier.app

import android.content.Context
import android.content.SharedPreferences

class ClavierPreferences(context: Context) {
    private val prefs: SharedPreferences =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    companion object {
        private const val PREFS_NAME = "eclavier_prefs"
        const val KEY_THEME = "key_theme" // "auto", "light", "dark"
        const val KEY_HAPTIC = "key_haptic"
        const val KEY_SOUND = "key_sound"
        const val KEY_PREVIEW = "key_preview"
        const val KEY_DEFAULT_LANG = "key_default_lang" // 1: Moore, 2: Dioula, 3: Fulfulde
        const val KEY_COFFEE_CONTACT = "key_coffee_contact"

        const val THEME_AUTO = "auto"
        const val THEME_LIGHT = "light"
        const val THEME_DARK = "dark"

        const val LANG_MOORE = 1
        const val LANG_DIOULA = 2
        const val LANG_FULFULDE = 3

        const val DEFAULT_CONTACT = "+226 55 31 24 57"
    }

    var themeMode: String
        get() = prefs.getString(KEY_THEME, THEME_AUTO) ?: THEME_AUTO
        set(value) = prefs.edit().putString(KEY_THEME, value).apply()

    var isHapticEnabled: Boolean
        get() = prefs.getBoolean(KEY_HAPTIC, true)
        set(value) = prefs.edit().putBoolean(KEY_HAPTIC, value).apply()

    var isSoundEnabled: Boolean
        get() = prefs.getBoolean(KEY_SOUND, false)
        set(value) = prefs.edit().putBoolean(KEY_SOUND, value).apply()

    var isPreviewEnabled: Boolean
        get() = prefs.getBoolean(KEY_PREVIEW, true)
        set(value) = prefs.edit().putBoolean(KEY_PREVIEW, value).apply()

    var defaultLangId: Int
        get() = prefs.getInt(KEY_DEFAULT_LANG, LANG_MOORE)
        set(value) = prefs.edit().putInt(KEY_DEFAULT_LANG, value).apply()

    var coffeeContact: String
        get() = prefs.getString(KEY_COFFEE_CONTACT, DEFAULT_CONTACT) ?: DEFAULT_CONTACT
        set(value) = prefs.edit().putString(KEY_COFFEE_CONTACT, value).apply()
}
