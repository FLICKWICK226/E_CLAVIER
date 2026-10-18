/*
 * File: rtwtypes.h
 * Portable standard C/C++ types for Android NDK and embedded systems.
 * Replaces MATLAB tmwtypes.h dependency with standard <stdint.h> and <stdbool.h>.
 */

#ifndef RTWTYPES_H
#define RTWTYPES_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

/* Boolean type definition */
#ifndef boolean_T
typedef unsigned char boolean_T;
#endif

#ifndef true
#define true 1
#endif

#ifndef false
#define false 0
#endif

/* Standard fixed width integer types */
#ifndef uint8_T
typedef uint8_t uint8_T;
#endif

#ifndef uint16_T
typedef uint16_t uint16_T;
#endif

#ifndef int32_T
typedef int32_t int32_T;
#endif

#ifndef uint32_T
typedef uint32_t uint32_T;
#endif

#ifndef int16_T
typedef int16_t int16_T;
#endif

#ifndef int8_T
typedef int8_t int8_T;
#endif

#endif /* RTWTYPES_H */
