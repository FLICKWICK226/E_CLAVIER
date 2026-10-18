% GENERATE_C_ENGINE Script d'automatisation MATLAB Coder (Option 1)
% Génère le code C natif (.c / .h) pour Android NDK et systèmes embarqués.
%
% UTILISATION DANS LA COMMAND WINDOW DE MATLAB :
%   >> generate_c_engine

fprintf('=== [E_CLAVIER] Demarrage de la generation C avec MATLAB Coder ===\n');

% 1. Configuration de generation : Bibliotheque C generique sans dependance
cfg = coder.config('lib');
cfg.TargetLang = 'C';
cfg.GenCodeOnly = true;       % Generer uniquement le code source .c / .h (pour Android NDK)
cfg.GenerateReport = true;    % Creer un rapport HTML detaille
cfg.FilePartitionMethod = 'MapMFileToCFile'; % 1 fichier .c par fichier .m

% 2. Definition des types d'entree statiques
sample_state = init_clavier_state();
type_state = coder.typeof(sample_state);
type_code_in = coder.typeof(uint16(0));
type_lang_id = coder.typeof(uint8(1));
type_is_shift = coder.typeof(false);

% 3. Dossier de sortie
output_dir = fullfile(pwd, 'codegen_c_engine');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% 4. Execution de la commande codegen
fprintf('Compilation du moteur logique en C...\n');
try
    codegen -config cfg -d output_dir ...
        init_clavier_state ...
        engine_insert_char -args {type_state, type_code_in} ...
        engine_backspace -args {type_state} ...
        engine_get_active_keys -args {type_lang_id, type_is_shift};
        
    fprintf('\n======================================================\n');
    fprintf(' SUCCES ! Moteur C genere dans le dossier :\n');
    fprintf(' -> %s\n', output_dir);
    fprintf(' Fichiers prets pour Android Studio (NDK / JNI) :\n');
    fprintf('   - engine_insert_char.c / .h\n');
    fprintf('   - engine_backspace.c / .h\n');
    fprintf('   - engine_get_active_keys.c / .h\n');
    fprintf('   - init_clavier_state.c / .h\n');
    fprintf('   - rtwtypes.h\n');
    fprintf('======================================================\n');
catch ME
    fprintf('\nERREUR lors de la generation C :\n%s\n', ME.message);
end
