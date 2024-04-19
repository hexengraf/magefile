#include "libA/moduleA/moduleB/componentH.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleBTest, componentHValue) {
  EXPECT_EQ(7, progA_moduleA_moduleB_componentH());
}
