# Spécifications Techniques & Directives de Compilation (`tech.md`)

Ce document consigne l'ensemble des directives de compilation, standards d'encodage, exigences d'architecture logicielle et résolutions de dysfonctionnements système pour le projet **E_CLAVIER**.

---

## 1. Standards Linguistiques & Encodage Numérique

1. **Standard National :** Alphabet National Burkinabè (ANB).
2. **Encodage Canonique :** Standard Unicode (ISO/IEC 10646), représenté en UTF-16 (`uint16_T`) dans les couches internes et sérialisé en UTF-8 dans les interfaces.
3. **Point de Code Consonantique du Coup de Glotte :**
   - Utilisation stricte de **`U+02BC`** (`700`, *Modifier Letter Apostrophe* `ʼ`).
   - L'utilisation du code ASCII `39` (`'`) est proscrite car reconnue comme signe de ponctuation par les moteurs de rendu, ce qui casse la césure et la segmentation des mots en langues burkinabè (notamment en Mooré).
>[!NOTE]
>reference: https://mail.academiedepolice.bf/index.php/telechargement/category/59-enseignement?download=183%3Aloi-portant-loi-d-orientation-sur-les-modalites-de-promotion-et-d-officialisation-des-langues-nationales-du-burkina-faso

---

## 2. Directives de Transpilation C ANSI (MATLAB Coder)

### 2.1 Typage Statique & Déterminisme
Le moteur algorithmique sous `matlab_version/` (`engine_*.m`, `init_clavier_state.m`) applique la directive `%#codegen` :
- Tous les tableaux ont des dimensions fixes et prédéfinies à la compilation.
- Aucune fonction d'allocation dynamique (`malloc`, `calloc`) n'est autorisée.
- Aucune dépendance graphique ou UI (`uifigure`, `uitextarea`) n'est injectée dans les fichiers soumis à `codegen`.

### 2.2 Rejet de la Virgule Fixe et de la Virgule Flottante
- **Types autorisés :** `uint16_T` (codepoints Unicode), `uint8_T` (identifiants de langue), `boolean_T` (indicateurs d'état).
- **Interdiction Formelle :** Ne jamais sélectionner les modes *Fixed-Point* ou *Single-Point* dans MATLAB Coder. Les caractères alphabétiques sont des scalaires entiers discrets. Toute conversion numérique continue introduit des imprécisions d'arrondi et viole les spécifications Unicode.

### 2.3 Script d'Automatisation de la Transpilation (`generate_c_engine.m`)
La génération s'effectue en une commande depuis MATLAB :
```matlab
cfg = coder.config('lib');
cfg.TargetLang = 'C';
cfg.GenerateReport = false;
codegen -config cfg -d 'codegen_c_engine' ...
    engine_insert_char -args {coder.typeof(uint16(0), [1 1024], [false true]), uint16(0), uint16(0)} ...
    engine_backspace   -args {coder.typeof(uint16(0), [1 1024], [false true]), uint16(0)} ...
    engine_get_active_keys -args {uint8(0), false} ...
    init_clavier_state;
```

---

---

## 3. Architecture Android NDK & Service Système IME
Le projet Android intègre le moteur C ANSI transpilé sans dépendance au SDK MATLAB :
```cmake
cmake_minimum_required(VERSION 3.22.1)
project("eclavier_engine")

set(C_ENGINE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../cpp_version")

add_library(${CMAKE_PROJECT_NAME} SHARED
    native-lib.cpp
    ${C_ENGINE_DIR}/engine_insert_char.c
    ${C_ENGINE_DIR}/engine_backspace.c
    ${C_ENGINE_DIR}/engine_get_active_keys.c
    ${C_ENGINE_DIR}/init_clavier_state.c
    ${C_ENGINE_DIR}/clavier_engine_initialize.c
    ${C_ENGINE_DIR}/clavier_engine_terminate.c
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${C_ENGINE_DIR})
find_library(log-lib log)
target_link_libraries(${CMAKE_PROJECT_NAME} ${log-lib})
```


