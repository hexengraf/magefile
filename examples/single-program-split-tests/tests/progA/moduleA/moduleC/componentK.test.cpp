#include "progA/moduleA/moduleC/componentK.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleCTest, componentKValue) {
  EXPECT_EQ(10, progA_moduleA_moduleC_componentK());
}
