function keys_out = engine_get_active_keys(lang_id, is_shift) %#codegen
% ENGINE_GET_ACTIVE_KEYS Retourne les 5 codes Unicode speciaux de la langue active.
% Entrees :
%   lang_id  (uint8)   : 1 = Moore, 2 = Dioula, 3 = Fulfulde
%   is_shift (logical) : false = Minuscule, true = Majuscule
% Sortie :
%   keys_out (1x5 uint16) : Vecteur des codes points (0 = touche inactive)

    LAYOUT_MIN = uint16([
        603, 617, 651,  39,   0;  % Moore    : ɛ, ɩ, ʋ, '
        603, 596, 626, 331,   0;  % Dioula   : ɛ, ɔ, ɲ, ŋ
        595, 599, 436, 626, 331   % Fulfulde : ɓ, ɗ, ƴ, ɲ, ŋ
    ]);
    
    LAYOUT_MAJ = uint16([
        400, 406, 434,  39,   0;  % Moore Maj    : Ɛ, Ɩ, Ʋ, '
        400, 390, 413, 330,   0;  % Dioula Maj   : Ɛ, Ɔ, Ɲ, Ŋ
        385, 394, 435, 413, 330   % Fulfulde Maj : Ɓ, Ɗ, Ƴ, Ɲ, Ŋ
    ]);

    idx = uint8(1);
    if lang_id >= 1 && lang_id <= 3
        idx = lang_id;
    end

    if is_shift
        keys_out = LAYOUT_MAJ(idx, :);
    else
        keys_out = LAYOUT_MIN(idx, :);
    end
end
