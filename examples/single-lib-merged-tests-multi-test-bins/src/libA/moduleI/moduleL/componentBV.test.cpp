#include "libA/moduleI/moduleL/componentBV.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleImoduleLTest, componentBVValue) {
  EXPECT_EQ(47, progA_moduleI_moduleL_componentBV());
}
