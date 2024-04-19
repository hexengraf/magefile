#include "progA/moduleA/moduleC/componentJ.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleCTest, componentJValue) {
  EXPECT_EQ(9, progA_moduleA_moduleC_componentJ());
}
