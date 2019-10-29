#include "murmur3.h"


uint32_t murmur3_32(const key_t key, uint32_t seed)
{

//	assert(len > 3);
//	assert(len <= 1024);
	uint32_t h = seed;

	size_t i = WIDTH >> 2;
	size_t j = 0;

	do {
#ifdef HLS
		assert(i <= 256);
		assert(i>0);
#endif
		uint32_t k = (uint32_t) (key >> (j*8*sizeof(uint32_t)));
		j++;
		k *= 0xcc9e2d51;
		k = (k << 15) | (k >> 17);
		k *= 0x1b873593;
		h ^= k;
		h = (h << 13) | (h >> 19);
		h = h * 5 + 0xe6546b64;
	} while (--i);
	
	h ^= WIDTH;
	h ^= h >> 16;
	h *= 0x85ebca6b;
	h ^= h >> 13;
	h *= 0xc2b2ae35;
	h ^= h >> 16;
	return h;
}
