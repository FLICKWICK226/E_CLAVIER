package com.eclavier.app

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.Toast
import androidx.appcompat.app.AppCompatDelegate
import androidx.fragment.app.Fragment
import com.google.android.material.button.MaterialButton
import com.google.android.material.switchmaterial.SwitchMaterial

class SettingsFragment : Fragment() {

    private lateinit var prefs: ClavierPreferences

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_settings, container, false)
        prefs = ClavierPreferences(requireContext())

        setupThemeGroup(root)
        setupFeedbackGroup(root)
        setupLangGroup(root)
        setupSystemButton(root)

        return root
    }

    private fun setupThemeGroup(root: View) {
        val rgTheme = root.findViewById<RadioGroup>(R.id.rg_theme)
        val rbAuto = root.findViewById<RadioButton>(R.id.rb_theme_auto)
        val rbLight = root.findViewById<RadioButton>(R.id.rb_theme_light)
        val rbDark = root.findViewById<RadioButton>(R.id.rb_theme_dark)

        when (prefs.themeMode) {
            ClavierPreferences.THEME_LIGHT -> rbLight.isChecked = true
            ClavierPreferences.THEME_DARK -> rbDark.isChecked = true
            else -> rbAuto.isChecked = true
        }

        rgTheme.setOnCheckedChangeListener { _, checkedId ->
            when (checkedId) {
                R.id.rb_theme_light -> {
                    prefs.themeMode = ClavierPreferences.THEME_LIGHT
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
                }
                R.id.rb_theme_dark -> {
                    prefs.themeMode = ClavierPreferences.THEME_DARK
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
                }
                else -> {
                    prefs.themeMode = ClavierPreferences.THEME_AUTO
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM)
                }
            }
            Toast.makeText(requireContext(), "Thème du clavier mis à jour", Toast.LENGTH_SHORT).show()
        }
    }

    private fun setupFeedbackGroup(root: View) {
        val switchHaptic = root.findViewById<SwitchMaterial>(R.id.switch_haptic)
        val switchSound = root.findViewById<SwitchMaterial>(R.id.switch_sound)
        val switchPreview = root.findViewById<SwitchMaterial>(R.id.switch_preview)

        switchHaptic.isChecked = prefs.isHapticEnabled
        switchSound.isChecked = prefs.isSoundEnabled
        switchPreview.isChecked = prefs.isPreviewEnabled

        switchHaptic.setOnCheckedChangeListener { _, isChecked -> prefs.isHapticEnabled = isChecked }
        switchSound.setOnCheckedChangeListener { _, isChecked -> prefs.isSoundEnabled = isChecked }
        switchPreview.setOnCheckedChangeListener { _, isChecked -> prefs.isPreviewEnabled = isChecked }
    }

    private fun setupLangGroup(root: View) {
        val rgLang = root.findViewById<RadioGroup>(R.id.rg_default_lang)
        val rbMoore = root.findViewById<RadioButton>(R.id.rb_lang_moore)
        val rbDioula = root.findViewById<RadioButton>(R.id.rb_lang_dioula)
        val rbFulfulde = root.findViewById<RadioButton>(R.id.rb_lang_fulfulde)

        when (prefs.defaultLangId) {
            ClavierPreferences.LANG_DIOULA -> rbDioula.isChecked = true
            ClavierPreferences.LANG_FULFULDE -> rbFulfulde.isChecked = true
            else -> rbMoore.isChecked = true
        }

        rgLang.setOnCheckedChangeListener { _, checkedId ->
            when (checkedId) {
                R.id.rb_lang_dioula -> prefs.defaultLangId = ClavierPreferences.LANG_DIOULA
                R.id.rb_lang_fulfulde -> prefs.defaultLangId = ClavierPreferences.LANG_FULFULDE
                else -> prefs.defaultLangId = ClavierPreferences.LANG_MOORE
            }
        }
    }

    private fun setupSystemButton(root: View) {
        root.findViewById<MaterialButton>(R.id.btn_open_system_ime).setOnClickListener {
            startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS))
        }
    }
}
