#include "progA/moduleI/moduleJ/componentBL.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleImoduleJTest, componentBLValue) {
  EXPECT_EQ(37, progA_moduleI_moduleJ_componentBL());
}
