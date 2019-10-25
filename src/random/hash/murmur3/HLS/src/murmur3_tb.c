/*
 * murmur3_tb.c
 *
 *  Created on: Oct 9, 2019
 *      Author: fourniem
 */


#include "stdlib.h"
#include "stdio.h"
//#include "ap_cint.h"
#include "murmur3.h"


uint32 murmur3_32(const uint8* key, size_t len, uint32 seed)
{
	uint32 h = seed;
	if (len > 3) {
		size_t i = len >> 2;
		do {
			uint32 k;
			memcpy(&k, key, sizeof(uint32));
			key += sizeof(uint32);
			k *= 0xcc9e2d51;
			k = (k << 15) | (k >> 17);
			k *= 0x1b873593;
			h ^= k;
			h = (h << 13) | (h >> 19);
			h = h * 5 + 0xe6546b64;
		} while (--i);
	}
	if (len & 3) {
		size_t i = len & 3;
		uint32 k = 0;
		do {
			k <<= 8;
			k |= key[i - 1];
		} while (--i);
		k *= 0xcc9e2d51;
		k = (k << 15) | (k >> 17);
		k *= 0x1b873593;
		h ^= k;
	}
	h ^= len;
	h ^= h >> 16;
	h *= 0x85ebca6b;
	h ^= h >> 13;
	h *= 0xc2b2ae35;
	h ^= h >> 16;
	return h;
}

int main(){
	uint32 seed = 0x12fc45ad;
	for (int i = 0; i < 100; i ++ ){
		const uint32 key = (int) random();

		uint32 realHash = murmur3_32((uint8*) &key, 4, seed);
		uint32 hlsHash = murmur3(key, seed);

//		assert(realHash == hlsHash);
		if(realHash != hlsHash) {
			printf("error : %d != %d \n", realHash, hlsHash);
			return -1;
		}

	}

	printf("Ok\n\n\n");

	return 0;
}
