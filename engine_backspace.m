function state = engine_backspace(state) %#codegen
% ENGINE_BACKSPACE Supprime le dernier cluster de grapheme complet
% (lettre de base + tous ses diacritiques combinants U+0300..U+036F).

    if state.cursor_len == 0
        return; % Rien a supprimer
    end

    % Etape 1 : Purger tous les diacritiques combinants en fin de chaine (768..879)
    while (state.cursor_len > 0) && ...
          (state.buffer(state.cursor_len) >= 768) && ...
          (state.buffer(state.cursor_len) <= 879)
        state.buffer(state.cursor_len) = uint16(0);
        state.cursor_len = state.cursor_len - 1;
    end

    % Etape 2 : Supprimer le caractere de base lui-meme
    if state.cursor_len > 0
        state.buffer(state.cursor_len) = uint16(0);
        state.cursor_len = state.cursor_len - 1;
    end
end
