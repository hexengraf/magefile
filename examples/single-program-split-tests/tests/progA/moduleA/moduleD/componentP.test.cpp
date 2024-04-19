#include "progA/moduleA/moduleD/componentP.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleAmoduleDTest, componentPValue) {
  EXPECT_EQ(15, progA_moduleA_moduleD_componentP());
}
