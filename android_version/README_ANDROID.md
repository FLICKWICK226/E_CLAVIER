# E-Clavier Android (Version 2.0 Refondue)

## Vue d'Ensemble de la Refonte

Suite à un audit ergonomique et technique, l'application mobile a été intégralement restructurée pour éliminer le modèle obsolète du mini-bloc-notes et fournir une solution mobile de niveau industriel :

1. **Application Compagnon (`MainActivity`) à 3 Menus (Bottom Navigation Bar) :**
   - **Menu 1 : Accueil & Bac à Sable (`HomeFragment`)**
     - Vérification en temps réel de l'activation du clavier dans Android.
     - Vérification du statut de clavier actif par défaut.
     - Boutons d'accès direct guidé vers les paramètres système.
     - Bac à sable interactif de saisie avec boutons *Effacer* et *Copier*.
   - **Menu 2 : Paramètres (`SettingsFragment`)**
     - Sélection du Thème :
       - **Automatique** (suit le mode sombre/clair d'Android).
       - **Thème Clair** : touches en vert pastel **`#D1EDD3`**, fond de clavier contrasté, texte foncé `#1A331E`.
       - **Thème Sombre** : touches en vert sauge profond **`#5C7057`**, fond sombre `#232D22`, texte clair `#F0FDF4`.
     - Retours haptiques (Vibrations à la frappe on/off).
     - Sons des touches (on/off).
     - Langue par défaut au démarrage (Mooré, Dioula, Fulfuldé).
   - **Menu 3 : À Propos & Contribution (`AboutFragment`)**
     - Initiative étudiante de l'École Polytechnique de Ouagadougou (EPO).
     - Promotion citoyenne et respect de l'Alphabet National Burkinabè (ANB).
     - Liens directs vers le dépôt GitHub officiel et `CONTRIBUTING.md`.
     - Bouton *Offrir un café* qui copie instantanément le contact Mobile Money dans le presse-papiers avec Toast de notification.

2. **Clavier Système Universel (`ClavierService`) :**
   - **Toolbar Supérieure Intégrée :**
     - Badge dynamique affichant la langue courante (`MOORÉ`, `DIOULA`, `FULFULDÉ`) avec bascule instantanée en 1 tap.
     - 4 raccourcis rapides pour les diacritiques combinants : Ton Bas (`\u0300`), Ton Haut (`\u0301`), Circonflexe (`\u0302`), Tilde Nasal (`\u0303`).
   - **Rangée ANB Dédiée :**
     - 5 touches de caractères spéciaux adaptées à la langue sélectionnée (ex: `ɛ`, `ɩ`, `ʋ`, `ʼ`, `ŋ`).
   - **Pavé AZERTY Complet :**
     - 4 rangées standard complètes avec les 26 lettres de l'alphabet (A-Z).
     - Raccourcis en appui long (long-press popups) pour les variantes de voyelles et consonnes.
     - Coup de glotte officiel ANB **`ʼ`** (`U+02BC`).
     - Touche Shift avec mise à jour en direct de toutes les lettres (Minuscules/Majuscules).

