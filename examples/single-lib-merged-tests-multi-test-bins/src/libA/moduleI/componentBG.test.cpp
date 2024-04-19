#include "libA/moduleI/componentBG.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleITest, componentBGValue) {
  EXPECT_EQ(150, progA_moduleI_componentBG());
}
