function state = engine_backspace(state) %#codegen
    if state.cursor_len == 0, return; end
    while (state.cursor_len > 0) && (state.buffer(state.cursor_len) >= 768) && (state.buffer(state.cursor_len) <= 879)
        state.buffer(state.cursor_len) = uint16(0);
        state.cursor_len = state.cursor_len - 1;
    end
    if state.cursor_len > 0
        state.buffer(state.cursor_len) = uint16(0);
        state.cursor_len = state.cursor_len - 1;
    end
end
