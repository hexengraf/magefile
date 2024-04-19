#include "progA/moduleA/moduleB/componentE.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleBTest, componentEValue) {
  EXPECT_EQ(4, progA_moduleA_moduleB_componentE());
}
