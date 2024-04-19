#include "libA/moduleA/componentC.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleATest, componentCValue) {
  EXPECT_EQ(54, progA_moduleA_componentC());
}
