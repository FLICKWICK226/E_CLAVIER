# Guide du Développeur & Manuel de Déploiement (`DEVELOPER_GUIDE.md`)

Merci , d'etre arrive la. Ce document fournit le protocole pas-à-pas pour compiler, générer et tester les deux cibles du projet **E_CLAVIER** :
1. **L'application Desktop Windows (`ECLAVIER_ANB.exe`)**
2. **L'application & service système Android (`app-debug.apk`)**

---

## 1. Organisation du Répertoire & Arborescence

```text
Clavier_Multilingue_MATLAB_PC/
│
├── ECLAVIER_ANB.prj            # Projet de compilation MATLAB Application Compiler
├── ClavierMultilingueApp.m     # GUI principale MATLAB App Designer (Vue & Contrôleur)
├── generate_c_engine.m         # Script de transpilation automatisée MATLAB Coder
├── splash_clean.png            # Splash screen certifié 24bpp sans alpha (évite erreur 110)
│
├── matlab_version/             # Miroir certifié et scripts du moteur MATLAB
│   ├── engine_insert_char.m    # Moteur de validation linguistique (%#codegen)
│   ├── engine_backspace.m      # Moteur de suppression granulaire (%#codegen)
│   ├── engine_get_active_keys.m# Table des points de code ANB (%#codegen)
│   └── init_clavier_state.m    # Initialiseur de l'état statique (%#codegen)
│
├── cpp_version/                # Code source C ANSI transpilé et découplé
│   ├── engine_insert_char.c/.h # Implémentation C du moteur
│   ├── rtwtypes.h              # Types C portables (stdint.h / stdbool.h)
│   └── ...
│
└── docs/                       # Documentation technique & architecture
    ├── architecture.md         # Architecture 3-tiers & FSM linguistique
    ├── cahier_de_charges.md    # Cahier des charges et spécifications (PRD)
    ├── tech.md                 # Spécifications de compilation & résolutions de bugs
    └── DEVELOPER_GUIDE.md      # Le présent guide
```

---

## 2. Procédure 1 : Compilation de la Cible PC Windows (`.exe`)

### Prérequis
- MATLAB R2023b ou supérieur. matlab est un logiciel lourd qui peut occuper +de 14 Go il sert a de nombreux usage que ce soit de la programmation robotique de la compilation d'appli , la creation d'appli et excelle dans l'annotation de donnee qu'elles soient sonores ou ondulaires . si vous voulez juts une appli qui marche checker la version apk sur mobile . Nous avions prevu une laternative plus legere totalement refaite , les caracteristiques windows font wue l'on ne pourront pas aller jusqu'a definir le clavier comme clavier syteme . en fait Si maiiis protocolaire , du moins de mes recherches 
- MATLAB Compiler installé (`mcc`).
```
NB:  matlab est un logiciel lourd qui peut occuper +de 14 Go il sert a de nombreux usage que ce soit de la programmation robotique de la compilation d'appli , la creation d'appli et excelle dans l'annotation de donnee qu'elles soient sonores ou ondulaires . si vous voulez juts une appli qui marche checker la version apk sur mobile . Nous avions prevu une laternative plus legere totalement refaite , les caracteristiques windows font wue l'on ne pourront pas aller jusqu'a definir le clavier comme clavier syteme . en fait Si maiiis protocolaire , du moins de mes recherches .
```
### Étapes de Compilation
0. clonez le repo en locale .
1. Démarrer MATLAB et se placer dans le répertoire racine du projet :
   ```matlab
   cd('c:\chemin\Clavier_Multilingue_MATLAB_PC')
   ```
2. Lancer l'Application Compiler :
   - Soit en tapant `deploytool` dans la console de commandes MATLAB.
   - Soit en ouvrant directement le projet :
     ```matlab
     open('ECLAVIER_ANB.prj')
     ```
3. Vérifier les paramètres du projet :
   - **Fichier principal :** `matlab_version/ClavierMultilingueApp.m`
   - **Splash Screen :** `matlab_version/splash_clean.png` *(Obligatoire pour éviter l'erreur Win32 110)*.
   - **Fichiers inclus automatiquement :** `engine_*.m`, `init_clavier_state.m`.
4. Cliquer sur le bouton vert **Package**.
5. Les livrables sont générés dans :
   - `matlab_version/ClavierMultilingueApp/for_redistribution/` (Installateur autonome avec MATLAB Runtime)
   - `matlab_version/ClavierMultilingueApp/for_testing/` (Exécutable direct pour test immédiat)

---

## 3. Procédure 2 : Transpilation du Moteur en C ANSI (MATLAB Coder)

Pour mettre à jour le moteur C suite à toute modification des règles linguistiques dans les fichiers `.m` :

1. Dans la fenêtre de commande MATLAB, exécuter :
   ```matlab
   generate_c_engine
   ```
2. Le script génère automatiquement le code C ANSI autonome dans :
   - `matlab_version/codegen_c_engine/`
   - Et synchronise les sources vers `cpp_version/`.
A noter que c'est le fichier qui definit les regles claviers si vous aves besoin d'ajouter des caracteres ou personnaliser le clavier , c'est votre homme . 

---

## 4. Procédure 3 : Compilation de la Cible Mobile Android (`.apk`)

### Prérequis
- Android Studio (Ladybug / Koala ou version récente).
- Android SDK (API 24 à 36) et NDK (version 28.2 ou compatible).
- CMake (version 3.22.1+).

### Étapes de Compilation
1.  Creer et Ouvrir le projet Android dans Android Studio :  
   `C:\chemin\AndroidStudioProjects\E_CLAVIER`
2. Pour compiler directement depuis le terminal PowerShell :
   ```powershell
   cd "C:\chemin\AndroidStudioProjects\E_CLAVIER"
   .\gradlew.bat assembleDebug
   ```
3. Le fichier APK installable est produit dans :  
   `C:\chemin\AndroidStudioProjects\E_CLAVIER\app\build\outputs\apk\debug\app-debug.apk`

### Installation et Test sur Appareil / Émulateur Android
0. Connecter le smartphone Android en mode Débogage USB (ou lancer un émulateur). 
```
le deboggage est dispo apres avoir activer "le developper option" sur votre telephone. si vous etes peux familier , vous pouvez transferer l'apk via whatsapp , par cable usb , etc. i don't know if iphone allow APKs .
```
1. Installer l'APK :  
   ```powershell
   adb install -r "C:\chemin\AndroidStudioProjects\E_CLAVIER\app\build\outputs\apk\debug\app-debug.apk"

   ```
2. Lancer l'application **E-Clavier** :
   - Cliquer sur le **Bouton 1** : Activer le commutateur pour *E-Clavier* dans la liste des claviers système.
   - Cliquer sur le **Bouton 2** : Définir *E-Clavier* comme clavier par défaut.
2. Ouvrir n'importe quelle application de messagerie (WhatsApp, SMS, navigateur) : le clavier Burkinabè s'affiche et permet d'écrire en Mooré, Dioula et Fulfuldé.😎

---

## 5. Guide de Résolution des Problèmes Fréquents (Troubleshooting)

| Erreur / Symptôme                                                                                                                                              | Cause Racine                                                                                                                  | Solution Appliquée                                                                                                      |
| :------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------- |
| **Erreur Wi                                                                                                                                                    | Image splash screen avec transparence ARGB 32bpp ou dimensions non conformes. c'est juste un probleme de dimension de l'image | Utiliser exclusivement `matlab_ve **Crash immédiat de l'APK Android à l'ouverture**.# ca m'as fait vraiment poirroter la dessus je pense l'avoir corriger sinon .  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  er  | `MainActivity` appelait une fonction JNI inexistante (`stringFromJNI`) issue d'un template.                                   | Remplacement par une activité d'onboarding pure avec Intents système Android.                                                                                                                                                                                                              | Header propriétaire MathWorks manquant dans l'environnement Android.                                                          | Remplacement dans `rtwtypes.h` par les en-tê                                                                                                                                                                                                                                               | Utilisation de l'attribut `package` dans `AndroidManifest.xml` devenue obsolète et interdite.                                 | Supprimer `                                                                                                                                                                                                                                                                                | Perte de focus du widget `uitextarea` vers le premier bouton de l'interface.                                                                                                                                                                                                                                                                                                                                               | Utilisation du guillemet apostrophe ASCII `39` (`'`).                                                                         | Encodage conforme ANB Unicode avec la consonne modificatrice **`U+02BC`** (`700`).                                      |
