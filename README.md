# E_CLAVIER — Clavier Virtuel Multilingue (Mooré, Dioula, Fulfuldé)

**E_CLAVIER** est une application ouverte et gratuite de saisie de texte multilingue permettant d'écrire intégralement dans trois langues nationales majeures du Burkina Faso (**Mooré**, **Dioula**, **Fulfuldé**) en respectant les normes de l'**Alphabet National Burkinabè (ANB)** et le standard Unicode.

Ce projet est une initiative académique et citoyenne portée par un étudiant de l'**École Polytechnique de Ouagadougou (EPO)**.

---

## Fonctionnalités Principales

* **Support Natif de l'ANB (Mooré, Dioula, Fulfuldé) :**
  * **Mooré :** `ɛ`, `ɩ`, `ʋ`, `ʼ` (+ majuscules `Ɛ`, `Ɩ`, `Ʋ`)
  * **Dioula :** `ɛ`, `ɔ`, `ɲ`, `ŋ` (+ majuscules `Ɛ`, `Ɔ`, `Ɲ`, `Ŋ`)
  * **Fulfuldé :** `ɓ`, `ɗ`, `ƴ`, `ɲ`, `ŋ` (+ majuscules `Ɓ`, `Ɗ`, `Ƴ`, `Ɲ`, `Ŋ`)
* **Gestion Intelligente des Tons et de la Nasalisation (Post-Position) :**
  * Support des diacritiques combinants Unicode (`U+0300` à `U+036F`) : Ton bas (`◌̀`), Ton haut (`◌́`), Circonflexe (`◌̂`) et Tilde nasal (`◌̃`).
  * **Garde-fou linguistique intégré :** Empêche automatiquement l'insertion d'un diacritique orphelin (sur une consonne, un espace ou en début de texte) et limite la superposition à 2 diacritiques par voyelle (ex. voyelle nasalisée + ton : `ɛ̃́`).
* **Suppression par Cluster de Graphèmes (Smart Backspace) :**
  * Un seul clic sur *Retour (Backspace)* efface la lettre complète ainsi que tous ses diacritiques combinants rattachés, sans laisser d'accents flottants.
* **Double Mode de Saisie sur PC :**
  * **Clavier Virtuel à l'écran** (clic souris / écran tactile).
  * **Clavier Physique connecté** avec raccourcis rapides dédiés (`F1`–`F5` pour les lettres spéciales ANB, `F6`–`F9` pour les tons et la nasalisation).
* **Exportation Universelle :** Bouton **Copier le texte** intégré pour coller instantanément vos messages dans WhatsApp, Microsoft Word, un navigateur web ou vos SMS.

---

## Architecture du Projet & Variantes (MATLAB / Rust / C++)

Le dépôt est organisé en trois implémentations partageant exactement la même logique algorithmique :

1. **`matlab_version/` (Approche Académique MATLAB & App Designer) :**
   * Moteur algorithmique écrit en MATLAB pur avec structures statiques (`uint16`), transpilable en C/C++ natif via *MATLAB Coder*.
   * Interface graphique complète sous *MATLAB App Designer* (`ClavierMultilingueApp.m`), compilable en installateur autonome (`setup.exe`)[cite: 1].
2. **`rust_version/` (Alternative Native Ultra-Légère en Rust) :**
   * Pour les utilisateurs ne disposant pas du *MATLAB Runtime (MCR)*, une implémentation native en Rust garantissant la sécurité mémoire et un exécutable de quelques mégaoctets.
3. **`cpp_version/` (Moteur Natif C++17 & Pont Android JNI) :**
   * Implémentation standard en C++17 portable, compilable directement en `.exe` sous Windows (MinGW/MSVC) ou intégrable dans Android Studio via le NDK (`native-lib.cpp`).

---

## Raccourcis du Clavier Physique (Version PC)

Lorsque la fenêtre de l'application est active, vous pouvez taper directement sur votre clavier physique :

| Touche Physique | Action dans E_CLAVIER |
| :--- | :--- |
| **`F1` à `F5`** | Insère la 1re à la 5e lettre spéciale de la langue active (ex. `ɛ`, `ɩ`, `ʋ`, `'` en Mooré) |
| **`F6`** | Ajoute le **Ton Bas (`◌̀`)** sur la voyelle précédente (`U+0300`) |
| **`F7`** | Ajoute le **Ton Haut (`◌́`)** sur la voyelle précédente (`U+0301`) |
| **`F8`** | Ajoute l'**Accent Circonflexe (`◌̂`)** sur la voyelle précédente (`U+0302`) |
| **`F9`** | Ajoute le **Tilde Nasal (`◌̃`)** sur la voyelle précédente (`U+0303`) |
| **`Backspace`** | Supprime le dernier **cluster de graphèmes** complet (voyelle + diacritiques) |
| **`Entrée` / `Espace`** | Insère un saut de ligne ou un espace |

---

## Contribuer au Projet

Que vous soyez **développeur**, **linguiste** ou **locuteur natif**, vos remarques orthographiques et techniques constituent une contribution précieuse. Consultez le fichier **[CONTRIBUTING.md](./CONTRIBUTING.md)** pour participer.