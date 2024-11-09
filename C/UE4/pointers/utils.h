#pragma once

#define DEBUG(exp) printf("%s = %d\n", #exp, (exp))
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define ALEN(a) (sizeof(a)/sizeof(a[0]))
#define MIN_ALEN(a, b) MIN(ALEN(a), ALEN(b))
#define UNUSED(x) (void)(x)
