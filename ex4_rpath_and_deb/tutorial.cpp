#include <iostream>
#include <iomanip>
#include <limits>
#include <cstdlib>
#include <cstring>
#include <cmath>

#include "config.h"

#ifdef USE_MYSQRT
#include "mysqrt.h"
#endif

#define TO_STRING(token) TO_STRING2(token)
#define TO_STRING2(token) #token

int main(int argc, char *argv[])
{
   if (argc != 2) {
      std::cerr << "tutorial version " TO_STRING(TUTORIAL_VERSION_MAJOR) "." TO_STRING(TUTORIAL_VERSION_MINOR) "\n"
         "Usage: " << argv[0] << " num" << std::endl;
      return EXIT_FAILURE;
   }
   char *p;
   double num = std::strtod(argv[1], &p);
   if (p[strspn(p, " \t\n")] != '\0' || p == argv[1]) {
      std::cerr << "Error with argument" << std::endl;
      return EXIT_FAILURE;
   }

#ifdef MYSQRT
   num = mysqrt(num);
#else
   num = sqrt(num);
#endif

   std::cout << std::setprecision(std::numeric_limits<double/*decltype(num)*/>::max_digits10) << num << std::endl;
   
   return EXIT_SUCCESS;
}
