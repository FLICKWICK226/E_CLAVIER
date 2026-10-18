function keys_out = engine_get_active_keys(lang_id, is_shift) %#codegen
    LAYOUT_MIN = uint16([
        603, 617, 651, 700,   0;
        603, 596, 626, 331,   0;
        595, 599, 436, 626, 331
    ]);
    LAYOUT_MAJ = uint16([
        400, 406, 434, 700,   0;
        400, 390, 413, 330,   0;
        385, 394, 435, 413, 330
    ]);
    idx = uint8(1);
    if lang_id >= 1 && lang_id <= 3, idx = lang_id; end
    if is_shift, keys_out = LAYOUT_MAJ(idx, :); else, keys_out = LAYOUT_MIN(idx, :); end
end
