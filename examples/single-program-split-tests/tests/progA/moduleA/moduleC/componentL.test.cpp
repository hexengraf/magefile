#include "progA/moduleA/moduleC/componentL.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleCTest, componentLValue) {
  EXPECT_EQ(11, progA_moduleA_moduleC_componentL());
}
