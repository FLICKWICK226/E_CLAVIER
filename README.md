# E_CLAVIER — Clavier Système & Virtuel Multilingue (Mooré, Dioula, Fulfuldé)

**E_CLAVIER** est une solution complète, ouverte et gratuite de saisie de texte multilingue permettant d'écrire rigoureusement dans trois langues nationales majeures du Burkina Faso (**Mooré**, **Dioula**, **Fulfuldé**) en respectant les normes de l'**Alphabet National Burkinabè (ANB)** et le standard Unicode (ISO/IEC 10646).

Ce projet est une initiative citoyenne et académique portée par un étudiant de l'**École Polytechnique de Ouagadougou (EPO)**.

---

##  Deux Cibles Opérationnelles

Le projet livre deux applications concrètes et autonomes vous les trouverez dans le dossier /releases  :

1. **💻 Application PC Windows Autonome (`ECLAVIER_ANB.exe`) :**  
   Conçue avec MATLAB App Designer (`matlab_version/ClavierMultilingueApp.m`) et compilée avec le *MATLAB Application Compiler*. Permet la saisie rapide via des raccourcis industriels **`AltGr`** et l'export direct vers Word, Excel, les réseaux sociaux et les navigateurs.
2. **📱 Clavier Système Android v2.0 (`ECLAVIER_ANB.apk`) :**  
   Véritable service d'entrée système (**`InputMethodService`**) utilisable dans toutes les applications (WhatsApp, SMS, Facebook, TikTok, Word, navigateurs) :
   - **Application Compagnon à 3 Menus (Material 3) :**
     - **Accueil & Bac à Sable :** Statut d'activation système en temps réel et zone de saisie interactive pour s'entraîner.
     - **Paramètres :** Thème clair (**touches vert pastel `#D1EDD3`**), thème sombre (**touches vert sauge `#5C7057`**) ou automatique (suit Android), retours haptiques (vibrations) et sonores.
     - **À Propos & Soutien :** Initiative étudiante EPO, liens officiels GitHub / [CONTRIBUTING.md](CONTRIBUTING.md) et bouton pour copier le contact Mobile Money.
   - **Clavier Système Complet :** Toolbar supérieure ANB (switch dynamique de langue, 4 tons combinants), rangée ANB dédiée à 5 touches et pavé complet AZERTY (A-Z) avec raccourcis en appui long.

---

##  Fonctionnalités Principales

* **Support Intégral de l'ANB (Mooré, Dioula, Fulfuldé) :**
  * **Mooré :** `ɛ`, `ɩ`, `ʋ`, `ʼ` (+ majuscules `Ɛ`, `Ɩ`, `Ʋ`, `ʼ`)
  * **Dioula :** `ɛ`, `ɔ`, `ɲ`, `ŋ` (+ majuscules `Ɛ`, `Ɔ`, `Ɲ`, `Ŋ`)
  * **Fulfuldé :** `ɓ`, `ɗ`, `ƴ`, `ɲ`, `ŋ` (+ majuscules `Ɓ`, `Ɗ`, `Ƴ`, `Ɲ`, `Ŋ`)
  * *Norme de l'Apostrophe :* Utilisation stricte de la consonne Unicode **`U+02BC`** (*Modifier Letter Apostrophe* `ʼ`) pour le saltillo/coup de glotte.
* **Gestion Intelligente des Tons et de la Nasalisation (Automate FSM) :**
  * Support des diacritiques combinants Unicode (`U+0300` à `U+036F`) : Ton bas (`◌̀`), Ton haut (`◌́`), Circonflexe (`◌̂`) et Tilde nasal (`◌̃`).
  * **Garde-fous linguistiques :** Interdiction stricte des diacritiques orphelins (sur consonnes, espaces ou en début de mot).
* **Suppression par Cluster de Graphèmes (Smart Backspace) :**
  * Effacement propre de la voyelle et de ses diacritiques associés sans laisser d'accents flottants.
* **Ergonomie PC : Raccourcis Industriels `AltGr` :**
  * `AltGr + Touche Latine` pour les lettres spéciales (`AltGr + E` -> `ɛ`, `AltGr + I` -> `ɩ`, `AltGr + U` -> `ʋ`, `AltGr + '` -> `ʼ`).
  * `AltGr + 1..4` pour les tons et la nasalisation.

---

## 📁 Organisation Propre du Dépôt

```text
Clavier_Multilingue_MATLAB_PC/
│
├── .gitignore                      <-- Règles d'exclusion Git officielles
├── README.md                       <-- Présentation et documentation générale
├── CONTRIBUTING.md                 <-- Guide de contribution open source
├── sync_to_android_studio.ps1      <-- Script de déploiement automatique vers Android Studio
│
├── android_version/                <-- Sources Android v2.0 (Kotlin, layouts XML, drawables)
│   ├── README_ANDROID.md           (Documentation technique mobile complète)
│   └── app/                        (Module applicatif et service IME)
│
├── matlab_version/                 <-- Source unique MATLAB pour Desktop PC
│   ├── ClavierMultilingueApp.m     (Interface graphique App Designer)
│   ├── ClavierMultilingueApp.prj   (Configuration de packaging mcc)
│   ├── splash_clean.png            (Splash screen 24bpp certifié Win32)
│   ├── engine_*.m                  (Moteur algorithmique certifié %#codegen)
│   └── generate_c_engine.m         (Automatisation MATLAB Coder)
│
├── cpp_version/                    <-- Moteur universel C ANSI transpilé
│   ├── CMakeLists.txt              (Configuration NDK)
│   ├── native-lib.cpp              (Pont JNI)
│   └── engine_*.c / engine_*.h     (Sources C ANSI autonomes)
│
├── releases/                       <-- Binaire compilés prêts à l'emploi
│   ├── ECLAVIER_ANB.exe            (Exécutable Windows PC)
│   └── app-debug.apk               (Installable Android Mobile v2.0)
│
└── docs/                           <-- Documentation technique et académique
    ├── architecture.md             (Spécifications de l'architecture 3-tiers)
    ├── tech.md                     (Normes d'encodage, NDK et AGP 8)
    ├── DEVELOPER_GUIDE.md          (Guide pas-à-pas de build & troubleshooting)
    ├── cahier_de_charges.md        (Cahier des charges et spécifications)
```

---

## 🛠️ Compilation & Déploiement

### 1. Installer directement les Binaires Précompilés
Les binaires finaux générés sont disponibles dans le dossier [`releases/`](releases/) :
- **Sur PC :** Lancer [`releases/ECLAVIER_ANB.exe`](releases/ECLAVIER_ANB.exe).
- **Sur Smartphone Android :** lancer [`releases/ECLAVIER_ANB.apk`](releases/ECLAVIER_ANB.exe)
### 2.suivre les instruction :
* Sur PC: vous aurez besoin du logiciel` matlab runtime version 2023 ou +recentes`  il est assez lourds (environ 2go), bien sur il faudra etre connecte pour l'installation apres cela juste les  derniers setup et c'est tout bon . 
* Sur mobile : nous sommes  aller plus loin , vous pouvez utiliser le clavier dans vos systemes de messageries ( whatsapp, messager,instagram,snap etc ) il faudra juste installer l'appli le setup est intuitif . 
---

## 🤝 Contribuer au Projet

Que vous soyez **développeur**, **linguiste** ou **locuteur natif**, vos retours sont les bienvenus. Consultez **[CONTRIBUTING.md](./CONTRIBUTING.md)** pour proposer des améliorations ou reporter des bugs . 
