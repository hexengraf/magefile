#include "progA/moduleI/componentBH.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleITest, componentBHValue) {
  EXPECT_EQ(166, progA_moduleI_componentBH());
}
