function state = engine_insert_char(state, code_in) %#codegen
% ENGINE_INSERT_CHAR Insere un point de code Unicode dans le buffer avec garde-fou diacritique.
% Entrees :
%   state   (struct) : Etat courant du clavier
%   code_in (uint16) : Code point Unicode a inserer

    MAX_BUFFER = uint16(1024);
    if state.cursor_len >= MAX_BUFFER || code_in == 0
        return; % Tampon plein ou code nul ignore
    end

    % Voyelles autorisant les diacritiques combinants (Min + Maj)
    % a, e, i, o, u, ɛ, ɩ, ʋ, ɔ | A, E, I, O, U, Ɛ, Ɩ, Ʋ, Ɔ
    VOYELLES = uint16([97, 101, 105, 111, 117, 603, 617, 651, 596, ...
                       65,  69,  73,  79,  85, 400, 406, 434, 390]);

    % Verification si code_in est un diacritique combinant (U+0300 a U+036F : 768..879)
    is_diacritic = (code_in >= 768) && (code_in <= 879);

    if is_diacritic
        % 1. Interdit si le buffer est vide
        if state.cursor_len == 0
            return;
        end
        
        last_char = state.buffer(state.cursor_len);
        
        % 2. Interdit de doubler exactement le meme diacritique
        if last_char == code_in
            return;
        end

        % 3. Verifier si le caractere precedent est une voyelle ou un 1er diacritique
        if (last_char >= 768) && (last_char <= 879)
            % Il y a deja 1 diacritique : verifier que le caractere encore avant est une voyelle
            if state.cursor_len < 2
                return;
            end
            prev_char = state.buffer(state.cursor_len - 1);
            if ~any(VOYELLES == prev_char)
                return; % Deja 2 diacritiques ou base non-voyelle : rejet
            end
        else
            % Le dernier caractere est une lettre de base : doit etre une voyelle
            if ~any(VOYELLES == last_char)
                return; % Rejet sur consonne, espace ou ponctuation
            end
        end
    end

    % Insertion validee
    state.cursor_len = state.cursor_len + 1;
    state.buffer(state.cursor_len) = code_in;
end
