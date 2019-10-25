/*
 * murmur3.c
 *
 *  Created on: Oct 9, 2019
 *      Author: fourniem
 */
#include "murmur3.h"

uint32 murmur3(const uint32 key, uint32 seed)
{
	uint32 h = seed;
	uint32 k = key;
	k *= 0xcc9e2d51;
	k = (k << 15) | (k >> 17);
	k *= 0x1b873593;
	h ^= k;
	h = (h << 13) | (h >> 19);
	h = h * 5 + 0xe6546b64;
	h ^= sizeof(uint32);
	h ^= h >> 16;
	h *= 0x85ebca6b;
	h ^= h >> 13;
	h *= 0xc2b2ae35;
	h ^= h >> 16;
	return h;
}

