#include "gmock/gmock.h"

using namespace testing;

TEST(Go, TwoIsEven)
{
   std::cout << "here" << std::endl;
   ASSERT_THAT(2 % 2, Eq(0));
}
