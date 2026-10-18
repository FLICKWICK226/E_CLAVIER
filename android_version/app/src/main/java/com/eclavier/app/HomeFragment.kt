package com.eclavier.app

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.google.android.material.button.MaterialButton

class HomeFragment : Fragment() {

    private lateinit var ivStep1Status: ImageView
    private lateinit var tvStep1Desc: TextView
    private lateinit var btnStep1: MaterialButton

    private lateinit var ivStep2Status: ImageView
    private lateinit var tvStep2Desc: TextView
    private lateinit var btnStep2: MaterialButton

    private lateinit var etSandbox: EditText
    private lateinit var btnClear: MaterialButton
    private lateinit var btnCopy: MaterialButton

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_home, container, false)

        ivStep1Status = root.findViewById(R.id.iv_step1_status)
        tvStep1Desc = root.findViewById(R.id.tv_step1_desc)
        btnStep1 = root.findViewById(R.id.btn_step1)

        ivStep2Status = root.findViewById(R.id.iv_step2_status)
        tvStep2Desc = root.findViewById(R.id.tv_step2_desc)
        btnStep2 = root.findViewById(R.id.btn_step2)

        etSandbox = root.findViewById(R.id.et_sandbox)
        btnClear = root.findViewById(R.id.btn_sandbox_clear)
        btnCopy = root.findViewById(R.id.btn_sandbox_copy)

        setupActions()
        return root
    }

    override fun onResume() {
        super.onResume()
        checkKeyboardStatus()
    }

    private fun checkKeyboardStatus() {
        val context = requireContext()
        val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager ?: return
        val enabledList = imm.enabledInputMethodList
        val myPackage = context.packageName

        val isEnabled = enabledList.any { it.packageName == myPackage }
        if (isEnabled) {
            ivStep1Status.visibility = View.VISIBLE
            tvStep1Desc.setText(R.string.step1_active)
            btnStep1.isEnabled = false
            btnStep1.text = "✓ Activé"
        } else {
            ivStep1Status.visibility = View.GONE
            tvStep1Desc.setText(R.string.step1_desc)
            btnStep1.isEnabled = true
            btnStep1.setText(R.string.step1_btn)
        }

        // Vérification si clavier par défaut
        val currentIme = Settings.Secure.getString(context.contentResolver, Settings.Secure.DEFAULT_INPUT_METHOD)
        val isDefault = currentIme != null && currentIme.contains(myPackage)
        if (isDefault) {
            ivStep2Status.visibility = View.VISIBLE
            tvStep2Desc.setText(R.string.step2_active)
            btnStep2.isEnabled = false
            btnStep2.text = "✓ Clavier actif"
        } else {
            ivStep2Status.visibility = View.GONE
            tvStep2Desc.setText(R.string.step2_desc)
            btnStep2.isEnabled = isEnabled
            btnStep2.setText(R.string.step2_btn)
        }
    }

    private fun setupActions() {
        btnStep1.setOnClickListener {
            startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS))
        }

        btnStep2.setOnClickListener {
            val imm = requireContext().getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager
            imm?.showInputMethodPicker()
        }

        btnClear.setOnClickListener {
            etSandbox.setText("")
        }

        btnCopy.setOnClickListener {
            val text = etSandbox.text.toString()
            if (text.isNotEmpty()) {
                val clipboard = requireContext().getSystemService(Context.CLIPBOARD_SERVICE) as? ClipboardManager
                val clip = ClipData.newPlainText("E-Clavier Text", text)
                clipboard?.setPrimaryClip(clip)
                Toast.makeText(requireContext(), R.string.text_copied, Toast.LENGTH_SHORT).show()
            }
        }
    }
}
