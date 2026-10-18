package com.eclavier.app

/**
 * Moteur Linguistique ANB (Alphabet National Burkinabè)
 * Implémentation certifiée conforme à l'algorithme C ANSI et MATLAB Coder.
 */
object AnbEngine {

    const val LANG_MOORE = 1
    const val LANG_DIOULA = 2
    const val LANG_FULFULDE = 3

    // Coup de glotte consonnantique officiel ANB (U+02BC)
    const val CHAR_GLOTTAL = "ʼ"

    // 4 Signes Diacritiques Combinants Unicode
    const val TONE_LOW = "\u0300"    // Ton Bas (Accent grave combinant)
    const val TONE_HIGH = "\u0301"   // Ton Haut (Accent aigu combinant)
    const val TONE_CIRC = "\u0302"   // Ton Modulé / Circonflexe combinant
    const val TONE_NASAL = "\u0303"  // Nasalisation (Tilde combinant)

    // Voyelles éligibles aux tons et à la nasalisation
    private val VOWELS = setOf(
        'a', 'e', 'ɛ', 'i', 'ɩ', 'o', 'ɔ', 'u', 'ʋ',
        'A', 'E', 'Ɛ', 'I', 'Ɩ', 'O', 'Ɔ', 'U', 'Ʋ'
    )

    /**
     * Retourne les 5 touches spécifiques ANB pour la langue et l'état Shift demandés.
     */
    fun getSpecialKeys(langId: Int, isShift: Boolean): List<String> {
        return when (langId) {
            LANG_MOORE -> if (isShift) listOf("Ɛ", "Ɩ", "Ʋ", CHAR_GLOTTAL, "Ŋ") else listOf("ɛ", "ɩ", "ʋ", CHAR_GLOTTAL, "ŋ")
            LANG_DIOULA -> if (isShift) listOf("Ɛ", "Ɔ", "Ɲ", "Ŋ", CHAR_GLOTTAL) else listOf("ɛ", "ɔ", "ɲ", "ŋ", CHAR_GLOTTAL)
            LANG_FULFULDE -> if (isShift) listOf("Ɓ", "Ɗ", "Ƴ", "Ŋ", "Ɲ") else listOf("ɓ", "ɗ", "ƴ", "ŋ", "ɲ")
            else -> listOf("ɛ", "ɩ", "ʋ", CHAR_GLOTTAL, "ŋ")
        }
    }

    /**
     * Retourne le nom court de la langue active pour le badge Toolbar.
     */
    fun getLangDisplayName(langId: Int): String {
        return when (langId) {
            LANG_MOORE -> "🇧🇫 MOORÉ ▾"
            LANG_DIOULA -> "🇧🇫 DIOULA ▾"
            LANG_FULFULDE -> "🇧🇫 FULFULDÉ ▾"
            else -> "🇧🇫 MOORÉ ▾"
        }
    }

    /**
     * Vérifie si le caractère précédent autorise l'ajout d'un ton ou d'un tilde combinant.
     */
    fun canApplyDiacritic(prevChar: Char?): Boolean {
        if (prevChar == null) return false
        return VOWELS.contains(prevChar)
    }

    /**
     * Dictionnaire d'alternatives en appui long (Long-Press Popups)
     */
    fun getLongPressAlternatives(char: Char): List<String> {
        return when (char.lowercaseChar()) {
            'e' -> listOf("ɛ", "é", "è", "ê", "ë")
            'i' -> listOf("ɩ", "î", "ï")
            'o' -> listOf("ɔ", "ô", "ö")
            'u' -> listOf("ʋ", "û", "ù", "ü")
            'n' -> listOf("ŋ", "ɲ", "ñ")
            'd' -> listOf("ɗ")
            'b' -> listOf("ɓ")
            'y' -> listOf("ƴ", "ÿ")
            'a' -> listOf("à", "â", "ä")
            'c' -> listOf("ç")
            else -> emptyList()
        }
    }
}
