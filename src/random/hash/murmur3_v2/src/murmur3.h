#define HLS
#ifdef HLS
#include "ap_cint.h"
#include "assert.h"

#define uint32_t uint32
#define uint8_t uint8
#define size_t uint7
#else
#define uint32_t int
#define uint8_t char

#include <string.h>
#endif
#define WIDTH 128
#define key_t uint128

uint32_t murmur3_32(const key_t key, uint32_t seed);
