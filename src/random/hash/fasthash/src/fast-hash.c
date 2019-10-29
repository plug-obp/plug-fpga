#include <stdint.h>
#include <stddef.h>
#include <ap_cint.h>
#define mix(h) ({					\
			(h) ^= (h) >> 23;		\
			(h) *= 0x2127599bf4325c37ULL;	\
			(h) ^= (h) >> 47; })
#define mmax(a,b) ((a)>(b))?(a):(b)

uint64_t m = 0x880355f21e6d1965ULL;
uint64_t h = 0;

uint64_t fasthash64(const uint64_t inData, size_t len, uint2 step, uint64_t seed) {
	uint64_t result = 0;
	switch (step) {
	case 2: {
		uint64_t v = inData;
		h = (h==0) ? mmax((seed^(len*m)),1) : h;
		h ^= mix(v);
		h *= m;
		result = 0;
		break;
	}
	case 3: {
		const unsigned char *pos2 = (const unsigned char*) &inData;
		uint64_t v = 0;
		switch (len & 7) {
		case 7:
			v ^= (uint64_t) pos2[6] << 48;
		case 6:
			v ^= (uint64_t) pos2[5] << 40;
		case 5:
			v ^= (uint64_t) pos2[4] << 32;
		case 4:
			v ^= (uint64_t) pos2[3] << 24;
		case 3:
			v ^= (uint64_t) pos2[2] << 16;
		case 2:
			v ^= (uint64_t) pos2[1] << 8;
		case 1:
			v ^= (uint64_t) pos2[0];
			h ^= mix(v);
			h *= m;
		}
		h = mix(h);
		result = h;
		h = 0;
		break;
	}
	default: break;/*nothing*/
	}

	return result;
}

//uint32_t fasthash32(const void *buf, size_t len, uint32_t seed)
//{
//	// the following trick converts the 64-bit hashcode to Fermat
//	// residue, which shall retain information from both the higher
//	// and lower parts of hashcode.
//        uint64_t h = fasthash64(buf, len, seed);
//	return h - (h >> 32);
//}
