#include "libA/moduleA/moduleB/componentG.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleBTest, componentGValue) {
  EXPECT_EQ(6, progA_moduleA_moduleB_componentG());
}
