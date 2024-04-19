#include "progA/moduleA/moduleC/componentI.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleCTest, componentIValue) {
  EXPECT_EQ(8, progA_moduleA_moduleC_componentI());
}
