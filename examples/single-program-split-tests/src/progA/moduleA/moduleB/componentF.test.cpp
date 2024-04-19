#include "progA/moduleA/moduleB/componentF.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleBTest, componentFValue) {
  EXPECT_EQ(5, progA_moduleA_moduleB_componentF());
}
