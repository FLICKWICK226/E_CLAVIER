/*
 * File: init_clavier_state.c
 *
 * MATLAB Coder version            : 23.2
 * C/C++ source code generated on  : 17-Oct-2026 16:21:03
 */

/* Include Files */
#include "init_clavier_state.h"
#include "init_clavier_state_types.h"
#include <string.h>

/* Function Definitions */
/*
 * Arguments    : struct0_T *state
 * Return Type  : void
 */
void init_clavier_state(struct0_T *state)
{
  memset(&state->buffer[0], 0, 1024U * sizeof(unsigned short));
  state->cursor_len = 0U;
  state->lang_id = 1U;
  state->is_shift = false;
}

/*
 * File trailer for init_clavier_state.c
 *
 * [EOF]
 */
