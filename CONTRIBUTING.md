# Guide de Contribution — Projet E_CLAVIER

Merci de votre intérêt pour **E_CLAVIER** ! Ce projet initié à l'**École Polytechnique de Ouagadougou (EPO)** est ouvert à toutes les contributions.

Vous n'avez **pas besoin d'être programmeur** pour contribuer : les retours linguistiques sur l'Alphabet National Burkinabè (ANB), les signalements de bugs et les propositions d'amélioration ergonomique sont essentiels.

---

## 1. Contributions Linguistiques (Locuteurs & Linguistes)

L'implémentation actuelle s'appuie sur la documentation disponible de l'Alphabet National Burkinabè (ANB). Si vous constatez une évolution orthographique ou souhaitez proposer une amélioration :
* Signaler une lettre spéciale manquante ou une variante dialectale pour le **Mooré**, le **Dioula** ou le **Fulfuldé**.
* Préciser une règle d'usage sur la combinaison des tons (`◌̀`, `◌́`, `◌̂`) et de la nasalisation (`◌̃`).
* Proposer l'ajout d'une nouvelle langue nationale du Burkina Faso (ex. *Bissa*, *Gulmancema*, *Dagara*, *Lyele*, *Bwamu*, etc.) avec sa table Unicode exacte (minuscules et majuscules).

### Comment soumettre une remarque ?
1. Ouvrez l'onglet **[Issues](https://github.com/FLICKWICK226/E_CLAVIER/issues)** sur GitHub.
2. Cliquez sur **New Issue** et décrivez votre suggestion linguistique ou votre question. Vos remarques constituent déjà une contribution directe au projet !

---

## 2. Contributions Techniques (MATLAB, Rust, C++)

### Règles d'Architecture (Modèle MVC)
1. **Dossier `matlab_version/` :** Les fichiers `init_clavier_state.m` et `engine_*.m` doivent obligatoirement conserver la directive `%#codegen` et n'utiliser que des types statiques (`uint16`, `uint8`, `logical`) compatibles avec **MATLAB Coder**[cite: 1].
2. **Dossiers `rust_version/` et `cpp_version/` :** Toute modification des règles de validation des diacritiques (`U+0300`..`U+036F`) ou de la suppression par cluster doit être répercutée de manière identique dans les trois langages.

### Procédure de Pull Request (PR)
1. Forkez le dépôt `https://github.com/FLICKWICK226/E_CLAVIER.git`.
2. Créez une branche dédiée (`git checkout -b feat/ma-contribution`).
3. Soumettez votre Pull Request avec une description claire des changements effectués.