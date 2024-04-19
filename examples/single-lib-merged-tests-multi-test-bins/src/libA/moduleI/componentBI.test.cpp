#include "libA/moduleI/componentBI.hpp"
#include <gtest/gtest.h>

TEST(progAmoduleITest, componentBIValue) {
  EXPECT_EQ(182, progA_moduleI_componentBI());
}
