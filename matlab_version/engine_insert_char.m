function state = engine_insert_char(state, code_in) %#codegen
    MAX_BUFFER = uint16(1024);
    if state.cursor_len >= MAX_BUFFER || code_in == 0, return; end
    VOYELLES = uint16([97, 101, 105, 111, 117, 603, 617, 651, 596, 65, 69, 73, 79, 85, 400, 406, 434, 390]);
    is_diacritic = (code_in >= 768) && (code_in <= 879);
    if is_diacritic
        if state.cursor_len == 0, return; end
        last_char = state.buffer(state.cursor_len);
        if last_char == code_in, return; end
        if (last_char >= 768) && (last_char <= 879)
            if state.cursor_len < 2, return; end
            prev_char = state.buffer(state.cursor_len - 1);
            if ~any(VOYELLES == prev_char), return; end
        else
            if ~any(VOYELLES == last_char), return; end
        end
    end
    state.cursor_len = state.cursor_len + 1;
    state.buffer(state.cursor_len) = code_in;
end
