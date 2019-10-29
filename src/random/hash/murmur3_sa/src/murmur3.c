#include "murmur3.h"


uint32_t murmur3_32(const uint32_t key[64], size_t len, uint32_t seed)
{
#pragma HLS INTERFACE ap_fifo depth=1024 port=key
//	assert(len > 3);
//	assert(len <= 1024);
	uint32_t h = seed;

	size_t i = len >> 2;
	size_t j = 0;

	do {
#ifdef HLS
		assert(i <= 256);
		assert(i>0);
#endif
		uint32_t k = key[j];
		j++;


//		j += 4;
		k *= 0xcc9e2d51;
		k = (k << 15) | (k >> 17);
		k *= 0x1b873593;
		h ^= k;
		h = (h << 13) | (h >> 19);
		h = h * 5 + 0xe6546b64;
	} while (--i);
	
	h ^= len;
	h ^= h >> 16;
	h *= 0x85ebca6b;
	h ^= h >> 13;
	h *= 0xc2b2ae35;
	h ^= h >> 16;
	return h;
}
