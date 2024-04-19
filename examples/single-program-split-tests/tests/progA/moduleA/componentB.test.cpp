#include "progA/moduleA/componentB.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleATest, componentBValue) {
  EXPECT_EQ(38, progA_moduleA_componentB());
}
