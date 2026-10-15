function state = init_clavier_state() %#codegen
    state.buffer = zeros(1, 1024, 'uint16');
    state.cursor_len = uint16(0);
    state.lang_id = uint8(1);
    state.is_shift = false;
end
