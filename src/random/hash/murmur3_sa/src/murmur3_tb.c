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


uint32_t murmur3_32_real(const char* key, size_t len, uint32_t seed)
{
	uint32_t h = seed;
	if (len > 3) {
		size_t i = len >> 2;
		do {
			uint32_t k;
			memcpy(&k, key, sizeof(uint32_t));
			key += sizeof(uint32_t);
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
		uint32_t k = 0;
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
	uint32_t seed = 0x12fc45ad;
	for (int i = 0; i < 100; i ++ ){
		int r1 = random();
		unsigned long long  r2 = random() << 32;

		const unsigned long long  key = r1 + r2;

		uint32_t realHash = murmur3_32_real((char*) &key, 8, seed);
		uint32_t hlsHash = murmur3_32((int*) &key, 8, seed);

//		assert(realHash == hlsHash);
		if(realHash != hlsHash) {
			printf("error : %d != %d \n", (unsigned int) realHash, (unsigned int) hlsHash);
			return -1;
		}

	}

	printf("Ok\n\n\n");

	return 0;
}
