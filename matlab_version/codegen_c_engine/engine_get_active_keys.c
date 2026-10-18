/*
 * File: engine_get_active_keys.c
 *
 * MATLAB Coder version            : 23.2
 * C/C++ source code generated on  : 17-Oct-2026 16:21:03
 */

/* Include Files */
#include "engine_get_active_keys.h"

/* Function Definitions */
/*
 * Arguments    : unsigned char lang_id
 *                boolean_T is_shift
 *                unsigned short keys_out[5]
 * Return Type  : void
 */
void engine_get_active_keys(unsigned char lang_id, boolean_T is_shift,
                            unsigned short keys_out[5])
{
  static const unsigned short LAYOUT_MAJ[15] = {400U, 400U, 385U, 406U, 390U,
                                                394U, 434U, 413U, 435U, 700U,
                                                330U, 413U, 0U,   0U,   330U};
  static const unsigned short LAYOUT_MIN[15] = {603U, 603U, 595U, 617U, 596U,
                                                599U, 651U, 626U, 436U, 700U,
                                                331U, 626U, 0U,   0U,   331U};
  int i;
  unsigned char idx;
  idx = 1U;
  if ((lang_id >= 1) && (lang_id <= 3)) {
    idx = lang_id;
  }
  if (is_shift) {
    for (i = 0; i < 5; i++) {
      keys_out[i] = LAYOUT_MAJ[(idx + 3 * i) - 1];
    }
  } else {
    for (i = 0; i < 5; i++) {
      keys_out[i] = LAYOUT_MIN[(idx + 3 * i) - 1];
    }
  }
}

/*
 * File trailer for engine_get_active_keys.c
 *
 * [EOF]
 */
