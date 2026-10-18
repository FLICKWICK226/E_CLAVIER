/*
 * File: engine_insert_char.c
 *
 * MATLAB Coder version            : 23.2
 * C/C++ source code generated on  : 17-Oct-2026 16:21:03
 */

/* Include Files */
#include "engine_insert_char.h"
#include "init_clavier_state_types.h"

/* Function Definitions */
/*
 * Arguments    : struct0_T *state
 *                unsigned short code_in
 * Return Type  : void
 */
void engine_insert_char(struct0_T *state, unsigned short code_in)
{
  static const unsigned short VOYELLES[18] = {
      97U, 101U, 105U, 111U, 117U, 603U, 617U, 651U, 596U,
      65U, 69U,  73U,  79U,  85U,  400U, 406U, 434U, 390U};
  int q0;
  if ((state->cursor_len < 1024) && (code_in != 0)) {
    unsigned int qY;
    boolean_T guard1;
    guard1 = false;
    if ((code_in >= 768) && (code_in <= 879)) {
      if (state->cursor_len != 0) {
        int b_state;
        b_state = state->buffer[state->cursor_len - 1];
        if (b_state != code_in) {
          if ((b_state >= 768) && (b_state <= 879)) {
            if (state->cursor_len >= 2) {
              boolean_T exitg1;
              boolean_T y;
              y = false;
              b_state = 0;
              exitg1 = false;
              while ((!exitg1) && (b_state < 18)) {
                q0 = state->cursor_len;
                qY = (unsigned int)q0 - 1U;
                if ((unsigned int)q0 - 1U > (unsigned int)q0) {
                  qY = 0U;
                }
                if (state->buffer[(int)qY - 1] == VOYELLES[b_state]) {
                  y = true;
                  exitg1 = true;
                } else {
                  b_state++;
                }
              }
              if (y) {
                guard1 = true;
              }
            }
          } else {
            boolean_T x[18];
            boolean_T exitg1;
            boolean_T y;
            for (q0 = 0; q0 < 18; q0++) {
              x[q0] = (b_state == VOYELLES[q0]);
            }
            y = false;
            b_state = 0;
            exitg1 = false;
            while ((!exitg1) && (b_state < 18)) {
              if (x[b_state]) {
                y = true;
                exitg1 = true;
              } else {
                b_state++;
              }
            }
            if (y) {
              guard1 = true;
            }
          }
        }
      }
    } else {
      guard1 = true;
    }
    if (guard1) {
      qY = state->cursor_len + 1U;
      if (qY > 65535U) {
        qY = 65535U;
      }
      state->cursor_len = (unsigned short)qY;
      state->buffer[state->cursor_len - 1] = code_in;
    }
  }
}

/*
 * File trailer for engine_insert_char.c
 *
 * [EOF]
 */
