#include <iostream>
#include <cassert>
#include <cmath>

#include "config.h"

#ifdef USE_MYSQRT
#include "mysqrt.h"
#endif

int main()
{
   assert(sqrt(3) == mysqrt(3));
   return 0;
}

