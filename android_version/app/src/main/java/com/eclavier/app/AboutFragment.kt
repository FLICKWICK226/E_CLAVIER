package com.eclavier.app

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.google.android.material.button.MaterialButton

class AboutFragment : Fragment() {

    private val repoUrl = "https://github.com/FLICKWICK226/E_CLAVIER.git"
    private val contribUrl = "https://github.com/FLICKWICK226/E_CLAVIER/blob/main/CONTRIBUTING.md"

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_about, container, false)
        val prefs = ClavierPreferences(requireContext())

        // Bouton Dépôt GitHub
        root.findViewById<MaterialButton>(R.id.btn_github).setOnClickListener {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(repoUrl))
            startActivity(intent)
        }

        // Bouton CONTRIBUTING.md
        root.findViewById<MaterialButton>(R.id.btn_contributing).setOnClickListener {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(contribUrl))
            startActivity(intent)
        }

        // Bouton Offrir un café (Copier le contact Mobile Money)
        root.findViewById<MaterialButton>(R.id.btn_coffee).setOnClickListener {
            val contact = prefs.coffeeContact
            val clipboard = requireContext().getSystemService(Context.CLIPBOARD_SERVICE) as? ClipboardManager
            val clip = ClipData.newPlainText("Contact Développeur", contact)
            clipboard?.setPrimaryClip(clip)

            val msg = getString(R.string.coffee_copied, contact)
            Toast.makeText(requireContext(), msg, Toast.LENGTH_LONG).show()
        }

        return root
    }
}
