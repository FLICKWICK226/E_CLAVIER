package com.eclavier.app

import android.content.Context
import android.content.res.Configuration
import android.graphics.Color
import android.inputmethodservice.InputMethodService
import android.media.AudioManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.widget.PopupMenu
import androidx.core.content.ContextCompat

class ClavierService : InputMethodService() {

    private lateinit var prefs: ClavierPreferences
    private var currentLangId = AnbEngine.LANG_MOORE
    private var isShift = false
    private var isSymbols = false

    private lateinit var rootView: LinearLayout
    private lateinit var tvActiveLang: TextView
    private lateinit var btnShift: ImageView
    private lateinit var anbKeys: List<TextView>
    private lateinit var letterKeys: List<TextView>

    override fun onCreate() {
        super.onCreate()
        prefs = ClavierPreferences(this)
        currentLangId = prefs.defaultLangId
    }

    override fun onCreateInputView(): View {
        rootView = LayoutInflater.from(this).inflate(R.layout.keyboard_view, null) as LinearLayout
        prefs = ClavierPreferences(this)

        initViews()
        applyTheme()
        updateKeyboardLabels()
        setupListeners()

        return rootView
    }

    override fun onStartInputView(info: EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        isShift = false
        isSymbols = false
        applyTheme()
        updateKeyboardLabels()
    }

    private fun initViews() {
        tvActiveLang = rootView.findViewById(R.id.tv_active_lang)
        btnShift = rootView.findViewById(R.id.key_shift)

        anbKeys = listOf(
            rootView.findViewById(R.id.key_anb_1),
            rootView.findViewById(R.id.key_anb_2),
            rootView.findViewById(R.id.key_anb_3),
            rootView.findViewById(R.id.key_anb_4),
            rootView.findViewById(R.id.key_anb_5)
        )

        val letterIds = listOf(
            R.id.key_a, R.id.key_z, R.id.key_e, R.id.key_r, R.id.key_t,
            R.id.key_y, R.id.key_u, R.id.key_i, R.id.key_o, R.id.key_p,
            R.id.key_q, R.id.key_s, R.id.key_d, R.id.key_f, R.id.key_g,
            R.id.key_h, R.id.key_j, R.id.key_k, R.id.key_l, R.id.key_m,
            R.id.key_w, R.id.key_x, R.id.key_c, R.id.key_v, R.id.key_b,
            R.id.key_n
        )
        letterKeys = letterIds.map { rootView.findViewById(it) }
    }

    private fun isDarkModeActive(): Boolean {
        return when (prefs.themeMode) {
            ClavierPreferences.THEME_DARK -> true
            ClavierPreferences.THEME_LIGHT -> false
            else -> {
                val nightModeFlags = resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
                nightModeFlags == Configuration.UI_MODE_NIGHT_YES
            }
        }
    }

    private fun applyTheme() {
        val isDark = isDarkModeActive()

        val rootBg = ContextCompat.getColor(this, if (isDark) R.color.keyboard_bg_dark else R.color.keyboard_bg_light)
        val keyBgRes = if (isDark) R.drawable.bg_key_dark else R.drawable.bg_key_light
        val actionBgRes = if (isDark) R.drawable.bg_key_action_dark else R.drawable.bg_key_action_light
        val anbBgRes = if (isDark) R.drawable.bg_key_anb_dark else R.drawable.bg_key_anb_light
        val toneBgRes = if (isDark) R.drawable.bg_key_tone_dark else R.drawable.bg_key_tone_light
        val textColor = ContextCompat.getColor(this, if (isDark) R.color.text_primary_dark else R.color.text_primary_light)

        rootView.setBackgroundColor(rootBg)

        // Lettres standard (#D1EDD3 en clair, #5C7057 en sombre)
        letterKeys.forEach { key ->
            key.setBackgroundResource(keyBgRes)
            key.setTextColor(textColor)
        }

        // Touches ANB
        anbKeys.forEach { key ->
            key.setBackgroundResource(anbBgRes)
            key.setTextColor(textColor)
        }

        // Diacritiques de tons
        val toneIds = listOf(R.id.btn_tone_low, R.id.btn_tone_high, R.id.btn_tone_circ, R.id.btn_tone_nasal)
        toneIds.forEach { id ->
            val btn = rootView.findViewById<TextView>(id)
            btn.setBackgroundResource(toneBgRes)
            btn.setTextColor(textColor)
        }

        // Touches modificateurs
        val actionViews = listOf(
            rootView.findViewById<View>(R.id.key_shift),
            rootView.findViewById<View>(R.id.key_backspace),
            rootView.findViewById<View>(R.id.key_symbols),
            rootView.findViewById<View>(R.id.key_globe),
            rootView.findViewById<View>(R.id.key_enter)
        )
        actionViews.forEach { it.setBackgroundResource(actionBgRes) }

        // Espace & Coup de glotte
        rootView.findViewById<View>(R.id.key_space).setBackgroundResource(keyBgRes)
        rootView.findViewById<TextView>(R.id.key_apostrophe).apply {
            setBackgroundResource(keyBgRes)
            setTextColor(textColor)
        }
        rootView.findViewById<TextView>(R.id.key_dot).apply {
            setBackgroundResource(keyBgRes)
            setTextColor(textColor)
        }
    }

    private fun updateKeyboardLabels() {
        tvActiveLang.text = AnbEngine.getLangDisplayName(currentLangId)

        // 5 touches ANB dynamiques selon la langue
        val specials = AnbEngine.getSpecialKeys(currentLangId, isShift)
        specials.forEachIndexed { index, charStr ->
            if (index < anbKeys.size) {
                anbKeys[index].text = charStr
            }
        }

        // 26 lettres AZERTY
        letterKeys.forEach { keyView ->
            val charStr = keyView.text.toString()
            keyView.text = if (isShift) charStr.uppercase() else charStr.lowercase()
        }

        // Icône Shift
        btnShift.setColorFilter(
            if (isShift) ContextCompat.getColor(this, R.color.brand_green)
            else ContextCompat.getColor(this, if (isDarkModeActive()) R.color.white else R.color.black)
        )
    }

    private fun setupListeners() {
        // Clic sur les lettres AZERTY
        letterKeys.forEach { keyView ->
            keyView.setOnClickListener {
                triggerFeedback()
                val text = keyView.text.toString()
                currentInputConnection?.commitText(text, 1)
                if (isShift) {
                    isShift = false
                    updateKeyboardLabels()
                }
            }

            keyView.setOnLongClickListener {
                triggerFeedback()
                val char = keyView.text.firstOrNull() ?: return@setOnLongClickListener false
                val alts = AnbEngine.getLongPressAlternatives(char)
                if (alts.isNotEmpty()) {
                    showAlternativesPopup(keyView, alts)
                    true
                } else false
            }
        }

        // Clic sur les touches ANB
        anbKeys.forEach { keyView ->
            keyView.setOnClickListener {
                triggerFeedback()
                val text = keyView.text.toString()
                currentInputConnection?.commitText(text, 1)
            }
        }

        // Diacritiques de tons
        rootView.findViewById<View>(R.id.btn_tone_low).setOnClickListener {
            commitDiacritic(AnbEngine.TONE_LOW)
        }
        rootView.findViewById<View>(R.id.btn_tone_high).setOnClickListener {
            commitDiacritic(AnbEngine.TONE_HIGH)
        }
        rootView.findViewById<View>(R.id.btn_tone_circ).setOnClickListener {
            commitDiacritic(AnbEngine.TONE_CIRC)
        }
        rootView.findViewById<View>(R.id.btn_tone_nasal).setOnClickListener {
            commitDiacritic(AnbEngine.TONE_NASAL)
        }

        // Coup de glotte ANB (U+02BC)
        rootView.findViewById<View>(R.id.key_apostrophe).setOnClickListener {
            triggerFeedback()
            currentInputConnection?.commitText(AnbEngine.CHAR_GLOTTAL, 1)
        }

        // Espace
        rootView.findViewById<View>(R.id.key_space).setOnClickListener {
            triggerFeedback()
            currentInputConnection?.commitText(" ", 1)
        }

        // Point
        rootView.findViewById<View>(R.id.key_dot).setOnClickListener {
            triggerFeedback()
            currentInputConnection?.commitText(".", 1)
        }

        // Backspace
        rootView.findViewById<View>(R.id.key_backspace).setOnClickListener {
            triggerFeedback()
            currentInputConnection?.deleteSurroundingText(1, 0)
        }

        // Shift
        btnShift.setOnClickListener {
            triggerFeedback()
            isShift = !isShift
            updateKeyboardLabels()
        }

        // Changement de Langue (Bouton Globe ou Badge)
        val switchLangAction = View.OnClickListener {
            triggerFeedback()
            currentLangId = when (currentLangId) {
                AnbEngine.LANG_MOORE -> AnbEngine.LANG_DIOULA
                AnbEngine.LANG_DIOULA -> AnbEngine.LANG_FULFULDE
                else -> AnbEngine.LANG_MOORE
            }
            updateKeyboardLabels()
        }
        tvActiveLang.setOnClickListener(switchLangAction)
        rootView.findViewById<View>(R.id.key_globe).setOnClickListener(switchLangAction)

        // Entrée
        rootView.findViewById<View>(R.id.key_enter).setOnClickListener {
            triggerFeedback()
            val ic = currentInputConnection ?: return@setOnClickListener
            val action = currentInputEditorInfo?.imeOptions?.and(EditorInfo.IME_MASK_ACTION)
            if (action != null && action != EditorInfo.IME_ACTION_NONE && action != EditorInfo.IME_ACTION_UNSPECIFIED) {
                ic.performEditorAction(action)
            } else {
                ic.sendKeyEvent(KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_ENTER))
                ic.sendKeyEvent(KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_ENTER))
            }
        }
    }

    private fun commitDiacritic(diacritic: String) {
        triggerFeedback()
        val ic = currentInputConnection ?: return
        val before = ic.getTextBeforeCursor(1, 0)
        val prevChar = before?.lastOrNull()

        if (AnbEngine.canApplyDiacritic(prevChar)) {
            ic.commitText(diacritic, 1)
        } else {
            // Rejet ou insertion directe
            ic.commitText(diacritic, 1)
        }
    }

    private fun showAlternativesPopup(anchor: View, alternatives: List<String>) {
        val popup = PopupMenu(this, anchor)
        alternatives.forEachIndexed { index, alt ->
            popup.menu.add(0, index, index, alt)
        }
        popup.setOnMenuItemClickListener { item ->
            val charStr = alternatives.getOrNull(item.itemId) ?: return@setOnMenuItemClickListener false
            currentInputConnection?.commitText(charStr, 1)
            true
        }
        popup.show()
    }

    private fun triggerFeedback() {
        if (prefs.isHapticEnabled) {
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vm = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
                vm?.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator?.vibrate(VibrationEffect.createOneShot(18, VibrationEffect.DEFAULT_AMPLITUDE))
            } else {
                @Suppress("DEPRECATION")
                vibrator?.vibrate(18)
            }
        }

        if (prefs.isSoundEnabled) {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
            audioManager?.playSoundEffect(AudioManager.FX_KEYPRESS_STANDARD, 1.0f)
        }
    }
}
