#include "libA/moduleA/componentA.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleATest, componentAValue) {
  EXPECT_EQ(22, progA_moduleA_componentA());
}
