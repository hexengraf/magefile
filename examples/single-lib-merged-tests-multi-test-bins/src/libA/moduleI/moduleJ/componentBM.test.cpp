#include "libA/moduleI/moduleJ/componentBM.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleImoduleJTest, componentBMValue) {
  EXPECT_EQ(38, progA_moduleI_moduleJ_componentBM());
}
