function state = init_clavier_state() %#codegen
% INIT_CLAVIER_STATE Initialise l'etat du modele du clavier multilingue.
% Compatible MATLAB Coder (C/C++) avec taille de buffer statique.

    state.buffer = zeros(1, 1024, 'uint16'); % Tampon texte UTF-16 (Zero-padde)
    state.cursor_len = uint16(0);            % Nombre actuel de code points actifs
    state.lang_id = uint8(1);                % 1 = Moore, 2 = Dioula, 3 = Fulfulde
    state.is_shift = false;                  % false = Minuscule, true = Majuscule
end
