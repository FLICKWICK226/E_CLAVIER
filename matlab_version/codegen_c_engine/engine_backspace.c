/*
 * File: engine_backspace.c
 *
 * MATLAB Coder version            : 23.2
 * C/C++ source code generated on  : 17-Oct-2026 16:21:03
 */

/* Include Files */
#include "engine_backspace.h"
#include "init_clavier_state_types.h"

/* Function Definitions */
/*
 * Arguments    : struct0_T *state
 * Return Type  : void
 */
void engine_backspace(struct0_T *state)
{
  if (state->cursor_len != 0) {
    int q0;
    unsigned int qY;
    boolean_T exitg1;
    exitg1 = false;
    while ((!exitg1) && (state->cursor_len > 0)) {
      int i;
      q0 = state->cursor_len - 1;
      i = state->buffer[q0];
      if ((i >= 768) && (i <= 879)) {
        state->buffer[q0] = 0U;
        q0 = state->cursor_len;
        qY = (unsigned int)q0 - 1U;
        if ((unsigned int)q0 - 1U > (unsigned int)q0) {
          qY = 0U;
        }
        state->cursor_len = (unsigned short)qY;
      } else {
        exitg1 = true;
      }
    }
    if (state->cursor_len > 0) {
      state->buffer[state->cursor_len - 1] = 0U;
      q0 = state->cursor_len;
      qY = (unsigned int)q0 - 1U;
      if ((unsigned int)q0 - 1U > (unsigned int)q0) {
        qY = 0U;
      }
      state->cursor_len = (unsigned short)qY;
    }
  }
}

/*
 * File trailer for engine_backspace.c
 *
 * [EOF]
 */
