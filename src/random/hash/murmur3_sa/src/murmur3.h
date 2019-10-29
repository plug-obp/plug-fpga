//#define HLS
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

uint32_t murmur3_32(const uint32_t key[1024], size_t len, uint32_t seed);
